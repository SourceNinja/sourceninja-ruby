module SourceNinja
  class RailTie < Rails::Railtie
    ActiveSupport.on_load(:after_initialize) do
      package_data = Sourceninja.process_bundle_info
      Sourceninja.send_package_info(package_data)
    end
  end
end
