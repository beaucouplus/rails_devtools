require "fastimage"
require "phlex-rails"
require "turbo-rails"
require "importmap-rails"

module Devtools
  class Engine < ::Rails::Engine
    isolate_namespace Devtools

    initializer "devtools.image_middleware" do |app|
      if Rails.env.development?
        app.middleware.use(ImageMiddleware)
      end
    end

    initializer "devtools.importmap" do
      Devtools.importmap.draw root.join("config/importmap.rb")
      Devtools.importmap.cache_sweeper watches: root.join("app/javascript")
      ActiveSupport.on_load(:action_controller_base) do
        before_action { Devtools.importmap.cache_sweeper.execute_if_updated }
      end
    end

    # Add views to autoload paths for Phlex
    config.autoload_paths << "#{root}/app/views"
    config.autoload_paths << "#{root}/app/views/layouts"
    config.autoload_paths << "#{root}/app/views/components"
  end
end
