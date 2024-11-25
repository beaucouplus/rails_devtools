# frozen_string_literal: true

module Devtools
  class ImageSearchForm
    include ActiveModel::Model

    def initialize(search: "")
      @search = search
    end

    def results
      folders = Devtools::Engine.asset_config.paths

      images_by_folder = Hash.new { |hash, key| hash[key] = [] }

      folders.each do |dir|
        Dir.glob("#{dir}/**/*#{@search}*").each do |path|
          image_info = ImageAssets::ImageInfo.new(path)
          next unless image_info.valid?

          dir = File.dirname(path).gsub(Rails.root.to_s, "")
          images_by_folder[dir] << image_info
        end
      end

      images_by_folder
    end

    private
  end
end
