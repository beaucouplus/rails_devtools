# frozen_string_literal: true

module RailsDevtools
  class Routes::RouteDetails < Components::ApplicationComponent
    include Phlex::Rails::Helpers::FormWith

    def initialize(route:)
      @route = route
    end

    def view_template
      turbo_frame_tag("drawer_content") do
        div(class: "mt-4 w-full sm:min-w-80") do
          engine_name
          div(class: "flex justify-between gap-x-2 items-center") do
            h3(class: "text-lg font-bold mb-2") { route_name }
            div(class: "badge badge-lg bg-base-300 text-sm") { @route.verb }
          end
          p(class: "text-sm text-neutral") { only_path }
          open_link
          segments
          div(class: "mt-4 pt-4 border-t-2 border-base-300 mt-2 text-sm text-neutral") do
            more_info_card
          end
          route_path_input
        end
      end
    end

    private

    def more_info_card
      case @route.kind
      when "controller"
        controller_card
      when "redirection"
        redirection_card
      when "rack_app"
        rack_app_card
      when "inline"
        inline_card
      when "engine"
        engine_card
      end
    end

    def route_name
      if @route.inline?
        @route.endpoint
      else
        "#{@route.name}_path"
      end
    end

    def redirection_card
      div(class: "card card-compact bg-white text-sm w-full shadow-sm mb-4 border border-base-300") do
        div(class: "card-body flex flex-col lg:flex-row lg:justify-between lg:items-center gap-4") do
          h3(class: "block text-lg font-bold mb-2") { "Redirection #{@route.redirection_info.status}" }
          div(class: "text-sm text-neutral") { @route.redirection_info.block }
        end
      end
    end

    def rack_app_card
      div(class: "card card-compact bg-white text-sm w-full shadow-sm mb-4 border border-base-300") do
        div(class: "card-body flex flex-col lg:flex-row lg:justify-between lg:items-center gap-4") do
          h3(class: "block text-lg font-bold mb-2") { "Custom rack app #{@route.name}" }
        end
      end
    end

    def engine_card
      div(class: "card card-compact bg-white text-sm w-full shadow-sm mb-4 border border-base-300") do
        div(class: "card-body flex flex-col lg:flex-row lg:justify-between lg:items-center gap-4") do
          h3(class: "block text-lg font-bold mb-2") { "Mounted engine #{@route.name}" }
        end
      end
    end

    def controller_card
      render Routes::RouteDetails::ControllerCard.new(
        controller_info: @route.controller_info
      )
    end

    def inline_card
      div(class: "card card-compact bg-white text-sm w-full shadow-sm mb-4 border border-base-300") do
        div(class: "card-body flex flex-col lg:flex-row lg:justify-between lg:items-center gap-4") do
          h3(class: "block text-lg font-bold mb-2") { @route.endpoint }
        end
      end
    end

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
          render RailsDevtools::Components::Lucide::ExternalLink.new(width: 16, height: 16)
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
      return if @route.inline?

      turbo_frame_tag("route_path_input_form") do
        div(data_controller: "turbo-form") do
          form_with(
            url: helpers.routes_route_path_input_path(@route.id),
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
