# frozen_string_literal: true

module Devtools
  class RouteSearchForm
    include ActiveModel::Model

    def initialize(search: "")
      @search = search.downcase
    end

    def results
      routes = []
      app_routes.each do |route|
        routes << Routes::RouteInfo.new(route, engine: "Application")
      end

      engine_routes.each do |engine, engine_routes|
        engine_routes.each do |route|
          routes << Routes::RouteInfo.new(route, engine: engine)
        end
      end

      routes.select { |route| route.name.downcase.include?(@search) }
        .group_by { |route| route.engine_info.name }
    end

    private

    def app_routes
      rails_routes.select { |r| valid_route?(r) && !r.app.engine? }
    end

    def engine_routes
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
