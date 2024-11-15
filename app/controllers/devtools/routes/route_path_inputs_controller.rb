# frozen_string_literal: true

module Devtools
  module Routes
    class RoutePathInputsController < ApplicationController
      def update
        found_route = Routes::ProjectRoute.find(
          id: params[:id],
          controller: params[:route_controller],
          action: params[:route_action],
          engine: params[:route_engine]
        )

        route = Routes::RouteInfo.new(ActionDispatch::Routing::RouteWrapper.new(found_route), engine: params[:route_engine])

        input_params = {route: route}
        input_params.merge!(prefix: route.engine_info.helper_prefix) if params[:engine_prefix].present? && params[:engine_prefix] == "1"
        input_params.merge!(suffix: "url") if params[:url_suffix].present? && params[:url_suffix] == "1"

        render Routes::RouteDetails::RoutePathInput.new(**input_params)
      end

      private

      def route_engine
        if params[:route_engine] == "Application"
          Rails.application
        else
          params[:route_engine].constantize
        end
      end
    end
  end
end
