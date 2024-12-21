# frozen_string_literal: true

module RailsDevtools
  module Components
    class Ui::SearchForm < Components::ApplicationComponent
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::Request

      def initialize(form:, path:, method:)
        @form = form
        @path = path
        @method = method
      end

      def view_template
        div(class: "flex gap-2 mt-4") do
          form_with(
            model: @form,
            url: @path,
            method: @method,
            data: { turbo_action: :advance },
            class: "w-full max-w-sm"
          ) do |form|
            label(class: "input input-bordered flex items-center gap-2 w-full grow") do
              form.text_field(:search,
                              { class: " w-full ", placeholder: "Type search then enter", value: search_params })
              search_icon
            end
          end

          reset_button if search_params.present?
        end
      end

      private

      def reset_button
        link_to(@path, class: "btn text-neutral", data: { turbo_action: :advance }) do
          render Components::Lucide::Close.new(width: 16, height: 16)
          plain "Reset"
        end
      end

      def search_params
        request.params.dig(@form.model_name.param_key.to_sym, :search)
      end

      def search_icon
        svg(
          xmlns: "http://www.w3.org/2000/svg",
          viewbox: "0 0 16 16",
          fill: "currentColor",
          class: "h-4 w-4 opacity-70"
        ) do |s|
          s.path(
            fill_rule: "evenodd",
            d:
              "M9.965 11.026a5 5 0 1 1 1.06-1.06l2.755 2.754a.75.75 0 1 1-1.06 1.06l-2.755-2.754ZM10.5 7a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0Z",
            clip_rule: "evenodd"
          )
        end
      end
    end
  end
end
