# frozen_string_literal: true

module RailsDevtools
  module AssetProviders
    class PropshaftConfig
      def provider
        :propshaft
      end

      def paths
        Rails.application.config.assets.paths.select { |p| p.to_s.end_with?("images") }
      end

      def used?
        defined?(Propshaft)
      end
    end
  end
end
