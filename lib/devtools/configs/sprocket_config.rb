# frozen_string_literal: true

module Devtools
  module Configs
    class SprocketConfig
      def provider
        :sprockets
      end

      def paths
        Rails.application.config.assets.paths
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