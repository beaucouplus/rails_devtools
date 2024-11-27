# frozen_string_literal: true

module Devtools
  module Configs
    class JsbundlingRailsConfig
      def provider
        :jsbundling_rails
      end

      def paths
        [Rails.root.join("app/javascript").to_s]
      end

      def used?
        Bundler.definition.dependencies.any? do |dep|
          dep.name == "jsbundling-rails"
        end
      end
    end
  end
end
