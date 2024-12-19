require "fastimage"
require "phlex-rails"
require "turbo-rails"

module Devtools
  class Engine < ::Rails::Engine
    isolate_namespace Devtools

    # rubocop:disable Layout/LineLength
    initializer "devtools.environment_check" do
      unless Rails.env.local?
        raise "Devtools can only be used in your local environment. Please make sure that it is not included in production environment in your gemfile."
      end
    end
    # rubocop:enable Layout/LineLength

    # Add views to autoload paths for Phlex
    config.autoload_paths << "#{root}/app/views"
    config.autoload_paths << "#{root}/app/views/layouts"
    config.autoload_paths << "#{root}/app/views/components"
  end
end
