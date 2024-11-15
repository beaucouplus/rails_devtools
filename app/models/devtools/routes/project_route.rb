# frozen_string_literal: true

module Devtools
  module Routes
    class ProjectRoute
      def self.find(id:, controller:, action:, engine:)
        new(
          id: id,
          controller: controller,
          action: action,
          engine: engine
        ).find
      end

      def initialize(id:, controller:, action:, engine:)
        @id = id
        @controller = controller
        @action = action
        @engine = engine
      end

      def find
        route_engine.routes.routes.find do |r|
          r.requirements[:action] == @action &&
            r.requirements[:controller] == @controller &&
            include_root?(r)
        end
      end

      private

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
