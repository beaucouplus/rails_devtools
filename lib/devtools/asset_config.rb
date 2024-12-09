# frozen_string_literal: true

module Devtools
  class AssetConfig
    def self.find
      providers = AssetProvider.new.list
      new(providers)
    end

    def initialize(providers)
      @providers = providers
    end

    def paths
      @paths ||= @providers.flat_map(&:paths)
    end

    def helper_snippet
      if vite_rails?
        "vite_image_tag"
      else
        "image_tag"
      end
    end

    def implicit_path
      if vite_rails?
        ""
      else
        "images/"
      end
    end

    def vite_rails?
      @providers.any? { |p| p.provider == :vite_rails }
    end
  end

  class AssetProvider
    PROVIDERS = [
      AssetProviders::SprocketConfig,
      AssetProviders::ViteRailsConfig,
      AssetProviders::JsbundlingRailsConfig,
      AssetProviders::ShakapackerConfig,
    ].freeze

    def list
      @list ||= PROVIDERS.select { |config| config.new.used? }.map(&:new)
    end
  end
end
