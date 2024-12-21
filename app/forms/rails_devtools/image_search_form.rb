# frozen_string_literal: true

module RailsDevtools
  class ImageSearchForm
    include ActiveModel::Model

    def initialize(search: "")
      @search = search
    end

    def results
      folders = RailsDevtools.asset_config.paths

      images_by_folder = Hash.new { |hash, key| hash[key] = [] }
      extensions = ImageAssets::ImageInfo::IMAGE_EXTENSIONS.map { |ext| ext.delete_prefix(".") }.join(",")

      folders.each do |dir|
        Dir.glob("#{dir}/**/*{#{@search.upcase}, #{@search.downcase}}*.{#{extensions}}").each do |path|
          image_info = ImageAssets::ImageInfo.new(path)
          next unless image_info.valid?

          dir = File.dirname(path).gsub(Rails.root.to_s, "")
          images_by_folder[dir] << image_info
        end
      end

      images_by_folder
    end
  end
end
