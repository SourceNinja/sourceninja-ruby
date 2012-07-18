require 'httparty'
require 'json'

module Sourceninja
  include HTTParty

  @@BASE_URI = "https://app.sourceninja.com/rubygems/1_0"

  def self.log(msg)
    if defined? Rails
      Rails.logger.debug msg
    else
      $stderr.puts msg
    end
  end

  def self.process_bundle_info
    # all we need in the dep list is the name of the module. the version number here won't be important because
    # Bundler will resolve that into the spec list below
    dep_list = {}
    Bundler.environment.dependencies.to_a.map{|b| b.to_s}.each do |dep|
      unless dep =~ %r{^\s*(\S+)}
        log("Sourceninja: Could not find the package name for #{dep.to_s}")
        next
      end
      dep_list[$1] = true
    end

    package_data = []
    spec_hash = Bundler.environment.specs.to_hash
    spec_hash.keys.each do |key|
      unless %r{Gem::Specification name=#{key} version=([\d.]+)} =~ spec_hash[key][0].to_s
        log("Sourceninja: Could not parse information for gem #{key}: #{spec_hash[key]}")
        next
      end
      package_data << { :package_name => key, :package_version => $1, :direct_requirement => (dep_list[key] || false) }
    end

    if package_data.empty?
      log("Sourceninja: Did not successfully parse any packages, will not attempt to upload information")
      return
    end

    package_data
  end

  def self.send_package_info(package_data_hash, options={})
    defaults = {
      :url => ENV['SOURCENINJA_UPLOAD_URL'] ? ENV['SOURCENINJA_UPLOAD_URL'] : @@BASE_URI,
      :token => ENV['SOURCENINJA_TOKEN'],
      :product_id => ENV['SOURCENINJA_PRODUCT_ID']
    }
    options = defaults.merge(options)

    if options[:token].nil? or options[:token] == ""
      log("Sourceninja: No token set, not uploading information to SourceNinja")
      return false
    end

    if options[:product_id].nil? or options[:product_id] == ""
      log("Sourceninja: No product ID set, not uploading information to SourceNinja")
      return false
    end

    params = { :id => options[:product_id], :token => options[:token], :package_info => { :package_details => package_data_hash }.to_json }
    # log("Sourceninja: Attempting to send package_info of #{params.to_s} to #{[options[:url],'rubygems/1_0'].join('/')}")

    response = nil
    begin
      log("Sourceninja: Sending package information to SourceNinja")
      response = HTTParty.post(options[:url], :body => params)
    rescue Exception => e
      log("Sourceninja: Error submitting data: #{e.message}")
      return false
    end

    log("Sourceninja: Received status #{response.code}")
    return response.code == 200
  end
end
