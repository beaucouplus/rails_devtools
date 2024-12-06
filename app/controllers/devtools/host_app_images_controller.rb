# frozen_string_literal: true

module Devtools
  class HostAppImagesController < BaseController
    IMAGE_EXTENSIONS = [
      ".jpg",
      ".jpeg",
      ".png",
      ".gif",
      ".svg",
      ".webp",
      ".avif",
      ".ico"
    ].freeze

    def show
      image_path = find_source_image
      return head :not_found unless image_path

      mime_type = Mime::Type.lookup_by_extension(params[:format])
      send_file image_path, type: mime_type, disposition: "inline"
    end

    private

    def image_path
      "#{params[:path]}.#{params[:format]}"
    end

    def image?
      IMAGE_EXTENSIONS.include?(extension(image_path))
    end

    def find_source_image
      return nil unless image?

      filename = CGI.unescape(File.basename(image_path))
      found = nil

      Devtools.asset_config.paths.each do |base_path|
        paths = Dir.glob("#{base_path}/**/*#{filename}*")
        found = paths.find { |file_path| File.file?(file_path) }
        break if found
      end

      found
    end

    def extension(path)
      File.extname(path).downcase
    end
  end
end
