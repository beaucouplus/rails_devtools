# frozen_string_literal: true

module Devtools
  class ImageAssets::ImageDetails < ApplicationComponent
    def initialize(image_info:)
      @image_info = image_info
    end

    def view_template
      turbo_frame_tag("drawer_content", class: "flex flex-col") do
        figure do
          plain helpers.vite_image_tag(@image_info.relative_asset_image_path, width: "400")
        end

        div(class: "mt-4") do
          h3(class: "text-lg font-bold") { @image_info.basename }
          div(class: "mt-4 pt-4 border-t-2 border-base-300 grid grid-cols-3 gap-x-4 gap-y-2 mt-2 text-sm text-neutral") do
            # Image size
            div(class: "text-right font-bold ") { "Image size" }
            div(class: "col-span-2") { "#{@image_info.width} x #{@image_info.height}" }

            # File size
            div(class: "text-right font-bold text-neutral") { "File size" }
            div(class: "col-span-2") { bytes_to_kb(@image_info.file_size) }
          end
        end

        image_tag_input

        div(class: "mt-8 pt-8 border-t-2 border-base-300 flex gap-x-2 justify-end") do
          delete_button
        end
      end
    end

    def image_tag_input
      div(class: "mt-8 w-full") do
        div(
          class: "join w-full",
          data_controller: "clipboard",
          data_clipboard_success_content_value: "Copied!"
        ) do
          input(
            value: @image_info.image_helper_snippet,
            class: "input input-bordered input-primary input-sm w-full join-item",
            data_clipboard_target: "source"
          )
          button(
            class: "btn btn-primary btn-outline btn-sm join-item",
            data_action: "clipboard#copy",
            data_clipboard_target: "button"
          ) { "Copy" }
        end
      end
    end

    def delete_button
      button_to(
        helpers.image_asset_path(@image_info.name, image_path: @image_info.path),
        class: "btn btn-outline btn-error btn-sm",
        method: :delete,
        form: { data: {
          turbo_confirm: "Are you sure you want to delete this image?",
          action: "turbo:submit-end->checkbox#toggle"
        }}
      ) do
        span { render Components::Lucide::Trash.new(width: 16, height: 16) }
        plain "delete"
      end
    end

    private

    def bytes_to_kb(bytes)
      kb = bytes.to_f / 1024
      "#{kb.round(2)} KB"
    end
  end
end
