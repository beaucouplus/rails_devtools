require "fastimage"
require "phlex-rails"
require "turbo-rails"

module Devtools
  class Engine < ::Rails::Engine
    isolate_namespace Devtools

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
