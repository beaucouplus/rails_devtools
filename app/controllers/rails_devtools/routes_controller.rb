# frozen_string_literal: true

module RailsDevtools
  class RoutesController < BaseController
    def index
      form = RouteSearchForm.new(search: form_params[:search])
      render Routes::Index.new(routes: form.results, form: form)
    end

    def show
      route = Routes::Collection.find(params[:id])
      render Routes::RouteDetails.new(route: route)
    end

    private

    def form_params
      params[:route_search_form] || { search: "" }
    end
  end
end
