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
          Rails.logger.info "Sourceninja: Could not find the package name for #{dep.to_s}"
          next
        end

        dep_list[$1] = true
      end

      package_data = []
      spec_hash = Bundler.environment.specs.to_hash
      spec_hash.keys.each do |key|
        unless %r{Gem::Specification name=#{key} version=([\d.]+)} =~ spec_hash[key][0].to_s
          Rails.logger.info "Sourceninja: Could not parse information for gem #{key}: #{spec_hash[key]}"
          next
        end
        package_data << { :package_name => key, :package_version => $1, :direct_requirement => (dep_list[key] || false) }
      end

      if package_data.empty?
        Rails.logger.info "Sourceninja: Did not successfully parse any packages, will not attempt to upload information"
        return
      end

      package_data
    end

    def self.send_package_info(package_data_hash)
      Rails.logger.debug "Sourceninja: Attempting to send package information to SourceNinja"

      base_uri = @@base_uri

      if not ENV['SOURCENINJA_UPLOAD_URL'].nil? and ENV['SOURCENINJA_UPLOAD_URL'] != ""
        Rails.logger.debug "Sourceninja: using #{ENV['SOURCENINJA_UPLOAD_URL']} for the upload URI"
        base_uri = ENV['SOURCENINJA_UPLOAD_URL']
      end

      if ENV['SOURCENINJA_TOKEN'].nil? or ENV['SOURCENINJA_TOKEN'] == ""
        Rails.logger.debug "Sourceninja: No SOURCENINJA_TOKEN set, not uploading information to SourceNinja"
        return
      end

      if ENV['SOURCENINJA_PRODUCT_ID'].nil? or ENV['SOURCENINJA_PRODUCT_ID'] == ""
        Rails.logger.debug "Sourceninja: No SOURCENINJA_PRODUCT_ID set, not uploading information to SourceNinja"
        return
      end

      params = { :id => ENV['SOURCENINJA_PRODUCT_ID'], :token => ENV['SOURCENINJA_TOKEN'], :package_info => { :package_details => package_data_hash }.to_json }
      Rails.logger.debug "Sourceninja: Attempting to send package_info of #{params.to_s} to #{[base_uri,'rubygems/1_0'].join('/')}"
      response = HTTParty.post([base_uri,'rubygems/1_0'].join('/'), :body => params )
      Rails.logger.debug "Sourceninja: Got back status #{response.code}"
    end
end
