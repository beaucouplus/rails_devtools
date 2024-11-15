# frozen_string_literal: true

module Devtools
  class ImageAssets::Index < ApplicationView
    def initialize(form:, images_by_folder: {})
      @images_by_folder = images_by_folder
      @form = form
    end

    def view_template
      render Components::PageContent.new do |page|
        page.page_title { "Image assets" }
        page.search_form(form: @form, path: helpers.image_assets_path)
        page.results { results }
      end
    end

    private

    def results
      if @images_by_folder.empty?
        div(class: "text-neutral") { "No results found" }
      else
        div(class: "flex flex-col gap-12") do
          @images_by_folder.each do |folder, images|
            div do
              h3(class: "text-lg font-bold mb-4 truncate") { folder }
              div(class: "flex gap-4 flex-wrap w-full items-start") do
                images.each do |image_info|
                  render ImageAssets::ImageCard.new(image_info: image_info)
                end
              end
            end
          end
        end
      end
    end
  end
end
