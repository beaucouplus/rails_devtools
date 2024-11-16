# frozen_string_literal: true

module Devtools
  module Routes
    class RouteDetails::RoutePathInput < Components::ApplicationComponent
      def initialize(route:, prefix: '', suffix: 'path')
        @route = route
        @prefix = prefix
        @suffix = suffix
      end

      def view_template
        turbo_frame_tag('route_path_input') do
          div(
            class: 'join w-full',
            data_controller: 'clipboard',
            data_clipboard_success_content_value: 'Copied!'
          ) do
            input(
              value: input_value,
              class: 'input input-bordered input-primary input-sm w-full join-item',
              data_clipboard_target: 'source'
            )
            button(
              class: 'btn btn-primary btn-outline btn-sm join-item',
              data_action: 'clipboard#copy',
              data_clipboard_target: 'button'
            ) { 'Copy' }
          end
        end
      end

      private

      def input_value
        "#{@prefix}#{@route.name}_#{@suffix}()"
      end

      def prefix
        return '' if @prefix.blank?

        "#{@prefix}."
      end
    end
  end
end
