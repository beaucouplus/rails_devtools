require "fastimage"

module Devtools
  class Engine < ::Rails::Engine
    isolate_namespace Devtools

    # Add views to autoload paths for Phlex
    config.autoload_paths << "#{root}/app/views"
    config.autoload_paths << "#{root}/app/views/layouts"
    config.autoload_paths << "#{root}/app/views/components"
  end
end
