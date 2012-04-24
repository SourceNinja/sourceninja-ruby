require 'httparty'
require 'json'

module Sourceninja
  include HTTParty

  @@base_uri = "https://app.sourceninja.com"

  def self.process_bundle_info
    # all we need in the dep list is the name of the module. the version number here won't be important because
    # Bundler will resolve that into the spec list below
    dep_list = {}
    Bundler.environment.dependencies.to_a.map{|b| b.to_s}.each do |dep|
      unless dep =~ %r{^\s*(\S+)}
        if defined? Rails
          Rails.logger.info "Sourceninja: Could not find the package name for #{dep.to_s}"
        end

        next
      end

      dep_list[$1] = true
    end

    package_data = []
    spec_hash = Bundler.environment.specs.to_hash
    spec_hash.keys.each do |key|
      unless %r{Gem::Specification name=#{key} version=([\d.]+)} =~ spec_hash[key][0].to_s
        if defined? Rails
          Rails.logger.info "Sourceninja: Could not parse information for gem #{key}: #{spec_hash[key]}"
        else
          $stderr.puts "Sourceninja: Could not parse information for gem #{key}: #{spec_hash[key]}"
        end
        next
      end
      package_data << { :package_name => key, :package_version => $1, :direct_requirement => (dep_list[key] || false) }
    end

    if package_data.empty?
      if defined? Rails
        Rails.logger.info "Sourceninja: Did not successfully parse any packages, will not attempt to upload information"
      end

      return
    end

    package_data
  end

  def self.send_package_info(package_data_hash)
    if defined? Rails
      Rails.logger.debug "Sourceninja: Attempting to send package information to SourceNinja"
    end

    base_uri = @@base_uri

    if not ENV['SOURCENINJA_UPLOAD_URL'].nil? and ENV['SOURCENINJA_UPLOAD_URL'] != ""
      if defined? Rails
        Rails.logger.debug "Sourceninja: using #{ENV['SOURCENINJA_UPLOAD_URL']} for the upload URI"
      end

      base_uri = ENV['SOURCENINJA_UPLOAD_URL']
    end

    if ENV['SOURCENINJA_TOKEN'].nil? or ENV['SOURCENINJA_TOKEN'] == ""
      if defined? Rails
        Rails.logger.debug "Sourceninja: No SOURCENINJA_TOKEN set, not uploading information to SourceNinja"
      end

      return
    end

    if ENV['SOURCENINJA_PRODUCT_ID'].nil? or ENV['SOURCENINJA_PRODUCT_ID'] == ""
      if defined? Rails
        Rails.logger.debug "Sourceninja: No SOURCENINJA_PRODUCT_ID set, not uploading information to SourceNinja"
      end

      return
    end

    params = { :id => ENV['SOURCENINJA_PRODUCT_ID'], :token => ENV['SOURCENINJA_TOKEN'], :package_info => { :package_details => package_data_hash }.to_json }

    if defined? Rails
      Rails.logger.debug "Sourceninja: Attempting to send package_info of #{params.to_s} to #{[base_uri,'rubygems/1_0'].join('/')}"
    end

    response = HTTParty.post([base_uri,'rubygems/1_0'].join('/'), :body => params )

    if defined? Rails
      Rails.logger.debug "Sourceninja: Got back status #{response.code}"
    end
  end
end
