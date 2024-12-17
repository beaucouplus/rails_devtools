# frozen_string_literal: true

module Devtools
  class ImageAssetsController < BaseController
    def show
      image_info = ImageAssets::ImageInfo.new(params[:image_path])
      render ImageAssets::ImageDetails.new(image_info: image_info)
    end

    def index
      form = ImageSearchForm.new(search: form_params[:search])
      render ImageAssets::Index.new(images_by_folder: form.results, form: form)
    end

    def destroy
      image_info = ImageAssets::ImageInfo.new(params[:image_path])
      raise "This is a not an image" unless image_info.valid?

      File.delete(image_info.full_path)

      respond_to do |format|
        format.html { redirect_to image_assets_path, notice: "Image was successfully destroyed." }
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.remove(image_info.full_path),
            turbo_stream.append(
              "flash_messages",
              Components::FlashMessage.new(
                message: "Image was successfully destroyed."
              )
            )
          ]
        }
      end
    end

    private

    def form_params
      params[:image_search_form] || { search: "" }
    end
  end
end
