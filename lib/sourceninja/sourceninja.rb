require 'httparty'
require 'json'

module Splinter
  class Splinter
    include HTTParty

    @@base_uri = "http://localhost:3000"

    def self.send_package_info
      Rails.logger.debug "Splinter: Attempting to send package information to SourceNinja"

      if ENV['SOURCENINJA_TOKEN'].nil? or ENV['SOURCENINJA_TOKEN'] == ""
        Rails.logger.debug "Splinter: No SOURCENINJA_TOKEN set, not uploading information to SourceNinja"
        return
      end

      if ENV['SOURCENINJA_PRODUCT_ID'].nil? or ENV['SOURCENINJA_PRODUCT_ID'] == ""
        Rails.logger.debug "Splinter: No SOURCENINJA_PRODUCT_ID set, not uploading information to SourceNinja"
        return
      end

      package_data = []
      spec_hash = Bundler.environment.specs.to_hash
      spec_hash.keys.each do |key|
        unless %r{Gem::Specification name=#{key} version=([\d.]+)} =~ spec_hash[key][0].to_s
          Rails.logger.info "Splinter: Could not parse information for gem #{key}: #{spec_hash[key]}"
          next
        end
        package_data << { :package_name => key, :package_version => $1 }
      end

      params = { :id => ENV['SOURCENINJA_PRODUCT_ID'], :token => ENV['SOURCENINJA_TOKEN'], :package_info => { :package_details => package_data}.to_json }
      Rails.logger.debug "Splinter: Attempting to send package_info of #{params.to_s}"
      response = HTTParty.post([@@base_uri,'/rubygems/1_0'].join('/'), :body => params )
      Rails.logger.debug "Splinter: Got back status #{response.code}"
     end
  end

  class RailTie < Rails::Railtie
    ActiveSupport.on_load(:after_initialize) do
      Splinter.send_package_info
    end
  end
end
