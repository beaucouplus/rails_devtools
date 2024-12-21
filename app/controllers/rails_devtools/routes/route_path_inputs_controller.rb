# frozen_string_literal: true

module RailsDevtools
  module Routes
    class RoutePathInputsController < ApplicationController
      def update
        route = Routes::Collection.find(params[:id])

        input_params = { route: route }

        if params[:engine_prefix].present? && params[:engine_prefix] == "1"
          input_params.merge!(prefix: route.engine_info.helper_prefix)
        end

        if params[:url_suffix].present? && params[:url_suffix] == "1"
          input_params.merge!(suffix: "url")
        end

        render Routes::RouteDetails::RoutePathInput.new(**input_params)
      end
    end
  end
end
