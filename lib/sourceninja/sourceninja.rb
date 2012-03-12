require 'httparty'
require 'json'

module Sourceninja
  class Sourceninja
    include HTTParty

    @@base_uri = "http://www.sourceninja.com/rubygems/1_0"

    def self.send_package_info
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

      package_data = []
      spec_hash = Bundler.environment.specs.to_hash
      spec_hash.keys.each do |key|
        unless %r{Gem::Specification name=#{key} version=([\d.]+)} =~ spec_hash[key][0].to_s
          Rails.logger.info "Sourceninja: Could not parse information for gem #{key}: #{spec_hash[key]}"
          next
        end
        package_data << { :package_name => key, :package_version => $1 }
      end

      if package_data.empty?
        Rails.logger.info "Sourceninja: Did not successfully parse any packages, will not attempt to upload information"
        return
      end

      params = { :id => ENV['SOURCENINJA_PRODUCT_ID'], :token => ENV['SOURCENINJA_TOKEN'], :package_info => { :package_details => package_data}.to_json }
      Rails.logger.debug "Sourceninja: Attempting to send package_info of #{params.to_s}"
      response = HTTParty.post([base_uri,'/rubygems/1_0'].join('/'), :body => params )
      Rails.logger.debug "Sourceninja: Got back status #{response.code}"
     end
  end

  class RailTie < Rails::Railtie
    ActiveSupport.on_load(:after_initialize) do
      Sourceninja.send_package_info
    end
  end
end
