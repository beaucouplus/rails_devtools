# frozen_string_literal: true

module Devtools
  module AssetProviders
    class SprocketConfig
      def provider
        :sprockets
      end

      def paths
        Rails.application.config.assets.paths.select { |p| p.to_s.end_with?("images") }
      end

      def used?
        Rails.application.config.respond_to?(:assets)
      end
    end
  end
end
