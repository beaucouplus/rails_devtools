# frozen_string_literal: true

module Devtools
  class RoutesController < BaseController
    def index
      form = RoutesSearchForm.new(search: form_params[:search])
      render Routes::Index.new(routes: form.results, form: form)
    end

    def show
      found_route = Routes::ProjectRoute.find(
        id: params[:id],
        controller: params[:route_controller],
        action: params[:route_action],
        engine: params[:route_engine]
      )

      route = ActionDispatch::Routing::RouteWrapper.new(found_route)

      render Routes::RouteDetails.new(
        route: Routes::RouteInfo.new(route, engine: params[:route_engine])
      )
    end

    private

    def form_params
      params[:routes_search_form] || { search: "" }
    end
  end
end
