# frozen_string_literal: true

module Devtools
  class AssetConfig
    def self.find
      case provider
      when :sprockets
        Configs::SprocketConfig.new
      when :vite_rails
        Configs::ViteRailsConfig.new
      when :jsbundling_rails
        Configs::JsbundlingRailsConfig.new
      when :shakapacker
        Configs::ShapakapackerConfig.new
      else
        raise "Unknown provider, please implement a new config"
      end
    end

    def self.provider
      AssetProvider.new.find
    end
  end

  class AssetProvider
    def find
      return :vite_rails if vite_rails?
      return :shakapacker if shakapacker?
      return :jsbundling_rails if jsbundling_rails?
      return :sprockets if sprockets?

      :unknown
    end

    def vite_rails?
      Rails.root.join("config/vite.json").exist?
    end

    def shakapacker?
      Rails.root.join("config", "shakapacker.yml").exist?
    end

    def sprockets?
      Rails.application.config.respond_to?(:assets)
    end

    def jsbundling_rails?
      Bundler.definition.dependencies.any? do |dep|
        dep.name == "jsbundling-rails"
      end
    end
  end
end
