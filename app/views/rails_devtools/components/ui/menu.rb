# frozen_string_literal: true

module RailsDevtools
  class Components::Ui::Menu < Components::ApplicationComponent
    include Phlex::Rails::Helpers::CurrentPage

    def view_template
      large_screen_menu
      small_screen_menu
    end

    private

    def large_screen_menu
      div(class: "hidden lg:block h-full") do
        menu_items(classes: "w-60 p-4") do
          div(class: "border-b-2 border-base-300 pl-4 pb-4 mb-2") do
            menu_title
          end
        end
      end
    end

    def small_screen_menu
      div(
        data_controller: "reveal",
        data_reveal_hidden_class: "hidden",
        class: "lg:hidden w-full p-3 bg-base-200"
      ) do
        div(class: "flex flex-col") do
          div(class: "flex justify-between") do
            menu_title
            button(data_action: " click->reveal#toggle", type: "button") do
              render Components::Lucide::Menu
            end
          end
        end
        div(
          data_reveal_target: "item",
          class: "hidden mt-2 pl-3 border-t-2 border-base-300 "
        ) do
          menu_items(classes: "")
        end
      end
    end

    def menu_title
      div(class: "flex gap-3") do
        render Components::Lucide::PocketKnife
        h2(class: "font-bold text-xl") { "Devtools" }
      end
    end

    MenuItem = Data.define(:icon, :name, :path)

    def menu_items(classes:, &block)
      ul(class: [classes, "menu bg-base-200 text-base-content h-full"]) do
        block.call if block_given?

        items.each do |menu_item|
          item = MenuItem.new(**menu_item)
          li do
            a(href: item.path, class: current_page?(item.path) && "active") do
              span(class: "mr-1") { render item.icon.new(width: 16, height: 16) }
              span { item.name }
            end
          end
        end
      end
    end

    def items
      [
        { icon: Lucide::Database, name: "Database tables", path: helpers.database_tables_path },
        { icon: Lucide::Package, name: "Gems", path: helpers.gems_path },
        { icon: Lucide::SignPost, name: "Routes", path: helpers.routes_path },
        { icon: Lucide::Images, name: "Image assets", path: helpers.image_assets_path }
      ]
    end
  end
end
