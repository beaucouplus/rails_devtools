require "fastimage"

module Devtools
  class Engine < ::Rails::Engine
    isolate_namespace Devtools

    def self.asset_config
      @asset_config ||= AssetConfig.find
    end

    initializer "devtools.image_middleware" do |app|
      if Rails.env.development?
        app.middleware.use(ImageMiddleware)
      end
    end

    # Add views to autoload paths for Phlex
    config.autoload_paths << "#{root}/app/views"
    config.autoload_paths << "#{root}/app/views/layouts"
    config.autoload_paths << "#{root}/app/views/components"
  end
end
