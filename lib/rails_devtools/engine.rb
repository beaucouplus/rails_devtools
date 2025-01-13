require "fastimage"
require "phlex-rails"
require "turbo-rails"

module RailsDevtools
  class Engine < ::Rails::Engine
    isolate_namespace RailsDevtools

    # rubocop:disable Layout/LineLength
    initializer "rails_devtools.environment_check" do
      unless Rails.env.local?
        raise "Rails Devtools can only be used in your local environment. Please make sure that it is not included in production environment in your gemfile."
      end
    end
    # rubocop:enable Layout/LineLength

    # Add views to autoload paths for Phlex
    config.autoload_paths << "#{root}/app/views"
    config.autoload_paths << "#{root}/app/views/layouts"
    config.autoload_paths << "#{root}/app/views/components"

    initializer "rails_devtools.add_helpers" do
      Rails.application.config.after_initialize do
        Rails.application.eager_load!
      end
    end

  end
end
