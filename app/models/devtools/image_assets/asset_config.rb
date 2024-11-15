# frozen_string_literal: true

module Devtools
  module ImageAssets
    class AssetConfig
      def self.find
        case provider
        when :sprockets
          SprocketConfig.new
        when :vite_rails
          ViteRailsConfig.new
        when :jsbundling_rails
          JsbundlingRailsConfig.new
        when :shakapacker
          ShapakapackerConfig.new
        else
          raise "Unknown provider, please implement a new config"
        end
      end

      def self.provider
        return :vite_rails if defined?(ViteRails)
        return :shakapacker if shakapacker?
        return :jsbundling_rails if jsbundling_rails?
        return :sprockets if sprockets?
        :unknown
      end

      private

      def shakapacker?
        shakapacker_config_path = Rails.root.join("config", "shakapacker.yml")
        File.exist?(shakapacker_config_path)
      end

      def sprockets?
        Rails.application.config.respond_to?(:assets) &&
          Rails.application.config.assets.enabled
      end

      def jsbundling_rails?
        Bundler.definition.dependencies.any? do |dep|
          dep.name == "jsbundling-rails"
        end
      end
    end
  end
end
