# frozen_string_literal: true

module Devtools
  module ImageAssets
    class ImageInfo
      IMAGE_EXTENSIONS = Set[
        ".jpg", ".jpeg", # JPEG
        ".png",          # PNG
        ".gif",          # GIF
        ".webp",         # WebP
        ".svg",          # SVG
        ".avif",         # AVIF
        ".ico"           # Favicon
      ].freeze

      def initialize(image_path)
        @image_path = image_path
      end

      def path
        @image_path
      end

      def valid?
        File.file?(path) && image?(path)
      end

      def image?(path)
        IMAGE_EXTENSIONS.include?(extension)
      end

      def basename
        @basename ||= File.basename(path)
      end

      def name
        basename.split(".").first
      end

      def extension
        File.extname(path).downcase
      end

      def file_size
        @file_size ||= FastImage.new(path).content_length
      end

      def image_helper_snippet
        "#{asset_config.helper_snippet}(\"#{relative_asset_image_path}\")"
      end

      def relative_asset_image_path
        return @relative_asset_image_path if defined?(@relative_asset_image_path)

        matching_path = asset_config.paths.find { |asset_path| path.start_with?(asset_path) }
        matching_base = Pathname.new(matching_path).join(asset_config.implicit_path)
        asset_path = Pathname.new(path)

        @relative_asset_image_path = asset_path
          .relative_path_from(matching_base)
          .to_s.sub("../", "")
      end

      def width
        size[0]
      end

      def height
        size[1]
      end

      delegate :provider, to: :asset_config

      private

      def size
        @size ||= FastImage.size(path)
      end

      def asset_config
        @asset_config ||= Devtools.asset_config
      end
    end
  end
end
