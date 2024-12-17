# frozen_string_literal: true

module Devtools
  module Routes
    class Collection
      def self.all
        new.all
      end

      def self.find(id)
        new.find(id)
      end

      def all
        return @all if defined?(@all)

        id = 0
        @all = []
        app_routes.each do |route|
          id += 1
          @all << Routes::RouteInfo.new(route, engine: "Application", id: id)
        end

        routes_by_engine.each do |engine, engine_routes|
          engine_routes.each do |route|
            id += 1
            @all << Routes::RouteInfo.new(route, engine: engine, id: id)
          end
        end

        @all
      end

      def find(id)
        all.find { |route| route.id == id.to_i }
      end

      private

      def app_routes
        rails_routes.select { |r| valid_route?(r) && !r.app.engine? }
      end

      def routes_by_engine
        engines = {}
        rails_routes.select { |r| r.app.engine? && r.app.app.name != "Devtools::Engine" }.each do |engine_route|
          engines[engine_route.app.app.name] = engine_route.app.app.routes.routes.select do |r|
            valid_route?(r)
          end
        end
        engines
      end

      def valid_route?(route)
        wrapped_route = ActionDispatch::Routing::RouteWrapper.new(route)
        !rails_route?(wrapped_route) &&
          !turbo_route?(wrapped_route) &&
          !wrapped_route.internal?
      end

      def rails_routes
        @rails_routes ||= Rails.application.routes.routes
      end

      def rails_route?(route)
        return true if route.path.include?("rails/")

        route.name&.include?("rails")
      end

      def turbo_route?(route)
        route.name&.start_with?("turbo")
      end
    end
  end
end
