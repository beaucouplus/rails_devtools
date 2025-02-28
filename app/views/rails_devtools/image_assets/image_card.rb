# frozen_string_literal: true

module RailsDevtools
  class ImageAssets::ImageCard < Components::ApplicationComponent
    def initialize(image_info:)
      @image_info = image_info
    end

    def view_template
      turbo_frame_tag(@image_info.full_path) do
        a(
          href: helpers.image_asset_path(
            @image_info.name,
            full_name: @image_info.basename,
            image_path: @image_info.full_path
          ),
          data: { turbo_frame: 'drawer_content', action: 'click->checkbox#toggle' },
          class: 'group'
        ) do
          div(class: 'card card-compact bg-white shadow-sm group-hover:bg-primary w-[150px]') do
            figure do
              img(
                src: helpers.host_app_image_path(@image_info.devtools_image_path),
                class: 'card-image',
                width: '150'
              )
            end

            div(class: 'card-body group-hover:text-primary-content') do
              p(class: 'text-xs truncate') { @image_info.basename }
            end
          end
        end
      end
    end
  end
end
