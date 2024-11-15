# frozen_string_literal: true

module Devtools
  module ImageAssets
    class SprocketConfig
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
