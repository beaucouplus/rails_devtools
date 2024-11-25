# frozen_string_literal: true

module Devtools
  class DashboardLayout < ApplicationView
    include Phlex::Rails::Layout
    include Phlex::Rails::Helpers::ContentFor
    include Phlex::Rails::Helpers::StripTags
    include Phlex::Rails::Helpers::JavascriptIncludeTag

    def view_template(&block)
      doctype

      html(data_theme: "nord") do
        head do
          title do
            content_for?(:title) ? strip_tags(yield(:title)) : "Maxime Souillat"
          end

          meta(name: "apple-mobile-web-app-title", content: "Maxime Souillat")
          meta(name: "viewport", content: "width=device-width,initial-scale=1")

          csrf_meta_tags
          csp_meta_tag

          script(src:"https://cdn.tailwindcss.com")
          link(
            href: "https://cdn.jsdelivr.net/npm/daisyui@4.12.14/dist/full.min.css",
            rel: "stylesheet",
            type: "text/css"
          )
        end

        body do
          main(class: "h-screen flex flex-col") do
            div(class: "grow lg:flex") do
              render Components::Ui::Menu
              right_drawer(&block)
            end
          end
        end
      end
    end

    private

    def right_drawer(&block)
      render Components::Ui::Drawer.new(id: "right_drawer", direction: "right") do |right_drawer|
        right_drawer.content { page_content(&block) }
        right_drawer.drawer_side do
          div(class: "p-4 bg-base-200 text-base-content min-h-full flex flex-col") do
            div(class: "flex flex-none justify-end mb-8") do
              label(
                for: "right_drawer",
                aria_label: "close sidebar",
                class: "btn bnt-square btn-outline btn-xs"
              ) do
                render Components::Lucide::Close.new(width: 16, height: 16)
              end
            end

            div(class: "flex flex-col mt-20 grow") do
              turbo_frame_tag("drawer_content", class: "flex flex-col h-full grow")
            end
          end
        end
      end
    end

    def page_content(&block)
      turbo_frame_tag("flash_messages")
      div(class: "mt-4 mb-16 max-w-screen-2xl mx-4", &block)
    end
  end
end
