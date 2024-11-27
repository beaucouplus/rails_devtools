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

      def used?
        Rails.root.join("config/vite.json").exist?
      end
    end
  end
end
