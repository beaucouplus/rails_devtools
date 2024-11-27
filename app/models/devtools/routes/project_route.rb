# frozen_string_literal: true

module Devtools
  module Routes
    class ProjectRoute
      def self.find(id:, controller:, action:, engine:, redirection: false)
        new(
          id: id,
          controller: controller,
          action: action,
          engine: engine,
          redirection: redirection
        ).find
      end

      def initialize(id:, controller:, action:, engine:, redirection: false)
        @id = id
        @controller = controller
        @action = action
        @engine = engine
        @redirection = redirection
      end

      def find
        route_engine.routes.routes.find do |r|
          found_route = if redirection?
            r.name == @id
          else
            find_by_requirements(r)
          end

          found_route && include_root?(r)
        end
      end

      private

      def redirection?
        @redirection
      end

      def find_by_requirements(route)
        route.requirements[:action] == @action &&
          route.requirements[:controller] == @controller
      end

      def include_root?(route)
        return true if route.verb != "GET"
        return true if @id == "root"
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
