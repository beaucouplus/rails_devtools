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

        @all = []
        @current_id = 0

        add_routes(app_routes, engine_name: "Application")
        process_engine_routes(rails_routes)

        @all
      end

      def find(id)
        all.find { |route| route.id == id.to_i }
      end

      private

      def add_routes(routes, engine_name:)
        routes.each do |route|
          @current_id += 1
          @all << Routes::RouteInfo.new(route, engine: engine_name, id: @current_id)
        end
      end

      def process_engine_routes(routes)
        routes.select { |r| r.app.engine? && r.app.app.name != "Devtools::Engine" }.each do |engine_route|
          engine = engine_route.app.app
          process_single_engine(engine: engine)
        end
      end

      def process_single_engine(engine:)
        valid_engine_routes = engine.routes.routes.select { |r| valid_route?(r) }
        add_routes(valid_engine_routes, engine_name: engine.name)

        nested_routes = engine.routes.routes
        nested_routes.select { |r| r.app.respond_to?(:engine?) && r.app.engine? }.each do |nested_engine_route|
          nested_engine = nested_engine_route.app.app
          process_single_engine(engine: nested_engine)
        end
      end

      def app_routes
        rails_routes.select { |r| valid_route?(r) }
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
