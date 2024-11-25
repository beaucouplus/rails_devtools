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

      def helper_snippet
        "image_tag"
      end

      def implicit_path
        "images/"
      end
    end
  end
end
