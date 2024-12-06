# frozen_string_literal: true

module Devtools
  module Routes
    class ProjectRoute
      def self.find(name:, controller:, action:, engine:, kind:)
        new(
          name: name,
          controller: controller,
          action: action,
          engine: engine,
          kind: kind
        ).find
      end

      def initialize(name:, controller:, action:, engine:, kind:)
        @name = name
        @controller = controller
        @action = action
        @engine = engine
        @kind = kind
      end

      def find
        route_engine.routes.routes.find do |r|
          case @kind
          when "controller"
            found_by_requirements?(r) && include_root?(r)
          when "redirection"
            r.name == @name
          when "inline"
            wrapped_route = ActionDispatch::Routing::RouteWrapper.new(r)
            wrapped_route.endpoint == @name
          when "rack_app"
            r.name == @name
          end
        end
      end

      private

      def found_by_requirements?(route)
        return false if !route.requirements.key?(:controller) || !route.requirements.key?(:action)

        route.requirements[:action] == @action &&
          route.requirements[:controller] == @controller
      end

      def include_root?(route)
        return true if route.verb != "GET"
        return true if @name == "root"
        route.name != "root"
      end

      def route_engine
        if @engine == "Application"
          Rails.application
        else
          @engine.constantize
        end
      end
    end
  end
end
