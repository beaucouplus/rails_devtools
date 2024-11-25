# frozen_string_literal: true

module Devtools
  module Configs
    class ViteRailsConfig
      def provider
        :vite_rails
      end

      def paths
        [Rails.root.join("app/frontend").to_s]
      end

      def helper_snippet
        "vite_image_tag"
      end

      def implicit_path
        ""
      end
    end
  end
end
