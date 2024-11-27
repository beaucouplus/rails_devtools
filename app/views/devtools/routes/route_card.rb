# frozen_string_literal: true

module Devtools
  class Routes::RouteCard < Components::ApplicationComponent
    def initialize(route:, engine:)
      @route = route
      @engine = engine
    end

    def view_template
      a(
        href: helpers.route_path(
          @route.name,
          route_engine: @engine,
          route_controller: @route.controller,
          route_action: @route.action,
          redirection: @route.redirection?
        ),
        data: { turbo_frame: "drawer_content", action: "click->checkbox#toggle" },
        class: "group flex w-full"
      ) do
        div(class: "card card-compact bg-white text-sm w-full shadow-sm") do
          div(class: "card-body") do
            div(class: "flex flex-col sm:flex-row justify-between sm:items-center gap-y-2 sm:gap-x-2") do
              div(class: "flex items-center") do
                h2(class: "inline-flex card-title !mb-0 leading-none text-base items-center") do
                  "#{@route.name}_path"
                end
                redirection_badge
                no_matching_controller_alert
              end
              div(class: "flex gap-2 items-center justify-between sm:justify-normal") do
                div(class: "truncate") { @route.path.gsub("(.:format)", "") }
                div(class: "badge badge-sm ml-1") { @route.verb }
              end
            end
          end
        end
      end
    end

    private

    def no_matching_controller_alert
      return if @route.redirection?
      return if @route.controller_info.action_exists?

      span(class: "text-error ml-1") do
        render Components::Lucide::TriangleAlert.new(width: 16, height: 16)
      end
    end

    def redirection_badge
      return unless @route.redirection?

      span(class: "badge badge-sm badge-accent ml-1") { @route.redirection_info.status }
    end
  end
end
