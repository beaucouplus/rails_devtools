# frozen_string_literal: true

module Devtools
  class HostAppImagesController < BaseController
    def show
      return head :not_found unless image?

      image_path = find_source_image
      mime_type = Mime::Type.lookup_by_extension(params[:format])
      send_file image_path, type: mime_type, disposition: "inline"
    end

    private

    def image_path
      "#{params[:path]}.#{params[:format]}"
    end

    def image?
      ImageAssets::ImageInfo::IMAGE_EXTENSIONS.include?(extension)
    end

    def find_source_image
      filename = CGI.unescape(File.basename(image_path))
      found = nil

      Devtools.asset_config.paths.each do |base_path|
        paths = Dir.glob("#{base_path}/**/*#{filename}*")
        found = paths.find { |file_path| File.file?(file_path) }
        break if found
      end

      found
    end

    def extension
      File.extname(image_path).downcase
    end
  end
end
