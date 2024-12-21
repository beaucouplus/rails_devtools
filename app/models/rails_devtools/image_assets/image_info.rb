# frozen_string_literal: true

module RailsDevtools
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

      def full_path
        @image_path
      end

      def valid?
        File.file?(@image_path) && image?
      end

      def image?
        FastImage.type(@image_path).present?
      end

      def basename
        @basename ||= File.basename(@image_path)
      end

      def name
        basename.split(".").first
      end

      def extension
        File.extname(@image_path).downcase
      end

      def file_size
        @file_size ||= FastImage.new(@image_path).content_length
      end

      def image_helper_snippet
        "#{asset_config.helper_snippet}(\"#{devtools_image_path}\")"
      end

      def devtools_image_path
        return @devtools_image_path if defined?(@devtools_image_path)

        matching_path = asset_config.paths.find { |asset_path| @image_path.start_with?(asset_path) }
        matching_base = Pathname.new(matching_path).join(asset_config.implicit_path)
        asset_path = Pathname.new(@image_path)

        @devtools_image_path = asset_path
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
        @size ||= FastImage.size(@image_path)
      end

      def asset_config
        @asset_config ||= RailsDevtools.asset_config
      end
    end
  end
end
