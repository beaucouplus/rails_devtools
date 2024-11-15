# frozen_string_literal: true

module Devtools
  class Routes::RouteDetails < ApplicationComponent
    include Phlex::Rails::Helpers::FormWith

    def initialize(route:)
      @route = route
    end

    def view_template
      turbo_frame_tag("drawer_content") do
        div(class: "mt-4 w-full sm:min-w-80") do
          engine_name
          div(class: "flex justify-between gap-x-2 items-center") do
            h3(class: "text-lg font-bold mb-2") { "#{@route.name}_path" }
            div(class: "badge badge-lg bg-base-300 text-sm") { @route.verb }
          end
          p(class: "text-sm text-neutral") { only_path }
          open_link
          segments
          div(class: "mt-4 pt-4 border-t-2 border-base-300 mt-2 text-sm text-neutral") do
            render Routes::RouteDetails::ControllerCard.new(
              controller_info: @route.controller_info
            )
          end

          route_path_input
        end
      end
    end

    private

    def engine_name
      return unless @route.engine_info.engine?

      div(class: "text-neutral opacity-75") do
        @route.engine_info.name
      end
    end

    def only_path
      @route.path.gsub("(.:format)", "")
    end

    def open_link
      return unless @route.controller_info.action_exists?
      return if @route.segments.any? || @route.verb != "GET"

      div(class: "mt-2 flex justify-end") do
        a(href: only_path, target: "_blank", class: "btn btn-xs btn-outline btn-neutral opacity-75") do
          render Devtools::Components::Lucide::ExternalLink.new(width: 16, height: 16)
          span { "Open" }
        end
      end
    end

    def segments
      return unless @route.segments.any?

      div(class: "mt-4 pt-4 border-t-2 border-base-300 mt-2 text-sm text-neutral") do
        h3(class: "text-lg font-bold mb-2") { "Segments" }
        ul(class: "flex gap-x-2") do
          @route.segments.each do |segment|
            li(class: "badge badge-md badge-outline badge-neutral opacity-75") { segment }
          end
        end
      end
    end

    def route_path_input
      turbo_frame_tag("route_path_input_form") do
        div(data_controller: "turbo-form") do
          form_with(
            url: helpers.routes_route_path_input_path(
              @route.name,
              route_engine: @route.engine_info.name,
              route_controller: @route.controller,
              route_action: @route.action
            ),
            method: :patch,
            data: { turbo_frame: "route_path_input", turbo_form_target: "form" }
          ) do |form|
            div(class: "flex gap-2") do
              engine_checkbox(form)
              div do
                label(class: "label cursor-pointer justify-normal gap-1") do
                  span(class: "label-text") { "URL" }
                  form.check_box(
                    :url_suffix,
                    class: "checkbox checkbox-xs",
                    data: { action: "change->turbo-form#submit" }
                  )
                end
              end
            end
          end
        end
      end
      render Routes::RouteDetails::RoutePathInput.new(route: @route)
    end

    def engine_checkbox(form)
      return unless @route.engine_info.engine?

      div do
        label(class: "label cursor-pointer justify-normal gap-1") do
          span(class: "label-text") { "engine" }
          form.check_box(:engine_prefix, class: "checkbox checkbox-xs", data: { action: "change->turbo-form#submit" })
        end
      end
    end
  end
end
