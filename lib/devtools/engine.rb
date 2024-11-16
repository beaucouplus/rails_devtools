require 'vite_ruby'
require 'fastimage'

module Devtools
  class Engine < ::Rails::Engine
    isolate_namespace Devtools
    delegate :vite_ruby, to: :class

    def self.vite_ruby
      @vite_ruby ||= ViteRuby.new(root: root)
    end

    # Expose compiled assets via Rack::Static when running in the host app.
    config.app_middleware.use(Rack::Static,
                              urls: ["/#{vite_ruby.config.public_output_dir}"],
                              root: root.join(vite_ruby.config.public_dir))

    initializer 'vite_rails_engine.proxy' do |app|
      if vite_ruby.run_proxy?
        app.middleware.insert_before 0, ViteRuby::DevServerProxy, ssl_verify_none: true, vite_ruby: vite_ruby
      end
    end

    initializer 'vite_rails_engine.logger' do
      config.after_initialize do
        vite_ruby.logger = Rails.logger
      end
    end

    # Add views to autoload paths for Phlex
    config.autoload_paths << "#{root}/app/views"
    config.autoload_paths << "#{root}/app/views/layouts"
    config.autoload_paths << "#{root}/app/views/components"
  end
end
