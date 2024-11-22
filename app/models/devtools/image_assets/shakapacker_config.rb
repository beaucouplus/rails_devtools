# frozen_string_literal: true

module Devtools
  module ImageAssets
    class ShakapackerConfig
      def provider
        :shakapacker
      end

      def paths
        return @paths if defined?(@paths)

        shakapacker_config_path = Rails.root.join("config", "shakapacker.yml")
        shakapacker_config = YAML.load_file(shakapacker_config_path)

        @paths = Set.new([shakapacker_config["source_path"]])
        additional_paths = Set.new(shakapacker_config["additional_paths"])
        @paths = @paths.merge!(additional_paths).to_a
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
