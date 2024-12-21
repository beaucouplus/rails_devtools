# frozen_string_literal: true

module RailsDevtools
  module Components
    class Ui::Drawer < Components::ApplicationComponent
      def initialize(id:, direction: "left", classes: "")
        @id = id
        @direction = direction
        @classes = classes
      end

      def view_template(&block)
        div(class: drawer_classes, data_controller: "checkbox") do
          input(id: @id, type: "checkbox", class: "drawer-toggle", data_checkbox_target: "checkbox")
          block.call
        end
      end

      def content(&)
        div(class: "drawer-content flex flex-col", &)
      end

      def drawer_side(&block)
        div(class: "drawer-side") do
          label(
            for: @id,
            aria_label: "close sidebar",
            class: "drawer-overlay"
          )
          block.call
        end
      end

      private

      def drawer_classes
        [
          "drawer",
          direction_class,
          @classes
        ].join(" ")
      end

      def direction_class
        @direction == "left" ? "" : "drawer-end"
      end
    end
  end
end
