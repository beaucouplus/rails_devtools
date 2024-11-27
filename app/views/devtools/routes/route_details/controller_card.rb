# frozen_string_literal: true

module Devtools
  module Routes
    class RouteDetails::ControllerCard < Components::ApplicationComponent
      def initialize(controller_info:)
        @controller_info = controller_info
      end

      delegate(
        :full_class_name,
        :action,
        :controller,
        :action_exists?,
        :file_path,
        to: :@controller_info
      )

      def view_template
        div(class: card_class) do
          div(class: "card-body") do
            div(class: [
                  "text-base flex justify-between gap-4 items-center",
                  error? && "text-error"
                ]) do
              div(class: "flex items-center ") do
                if error?
                  span(class: "mr-1") do
                    render Components::Lucide::TriangleAlert.new(width: 16, height: 16)
                  end
                end
                h4(class: "font-bold") { full_class_name }
              end
              span(class: "italic") { action }
            end

            if error?
              ul(class: "text-sm text-error mt-2") do
                if controller.nil?
                  li { "No controller found for this route." }
                else
                  li { "No action ##{action} found in associated controller." }
                end
              end
            end

            div(class: "card-actions justify-end mt-8") do
              controller_file_path_input
            end
          end
        end
      end

      private

      def card_class
        [
          "card card-compact bg-base-100 text-sm w-full shadow-sm mb-4",
          error? ? "border border-error" : "border border-base-300"
        ].compact.join(" ")
      end

      def error?
        !action_exists?
      end

      def controller_file_path_input
        div(
          class: "",
          data_controller: "clipboard",
          data_clipboard_success_content_value: "Copied!"
        ) do
          input(
            value: file_path,
            class: "hidden",
            data_clipboard_target: "source"
          )
          button(
            class: ["btn  btn-outline btn-xs", error? ? "btn-error" : "btn-primary"],
            data_action: "clipboard#copy",
            data_clipboard_target: "button"
          ) { "Copy file path" }
        end
      end
    end
  end
end
