# frozen_string_literal: true

require "test_helper"

module RailsDevtools
  module Routes
    class RoutePathInputsControllerTest < ActionDispatch::IntegrationTest
      include RailsDevtools::Engine.routes.url_helpers

      def setup
        @route = Routes::Collection.all.first
        @route_id = @route.id
      end

      test "render path with path suffix when no optional parameters" do
        patch routes_route_path_input_path(@route_id), xhr: true

        assert_response :success
        assert_equal "text/html", @response.media_type
        assert_match "#{@route.name}_path", response.body
      end

      test "render path with path suffix when url suffix enabled" do
        patch routes_route_path_input_path(@route_id), params: { url_suffix: "1" }, xhr: true

        assert_response :success
        assert_equal "text/html", @response.media_type
        assert_match "#{@route.name}_url", response.body
      end

      test "render path with engine prefix when engine prefix enabled" do
        route = Routes::Collection.all.last
        patch routes_route_path_input_path(route.id), params: { engine_prefix: "1" }, xhr: true

        assert_response :success
        assert_equal "text/html", @response.media_type

        refute_nil route.engine_info.helper_prefix
        assert_match route.engine_info.helper_prefix, response.body
      end


      test "render path with engine prefix and url suffix updates when both engine prefix and url suffix enabled" do
        route = Routes::Collection.all.last

        patch(
          routes_route_path_input_path(route.id),
          params: { engine_prefix: "1", url_suffix: "1" },
          xhr: true
        )

        assert_response :success
        assert_equal "text/html", @response.media_type
        assert_match "#{route.engine_info.helper_prefix}.#{route.name}_url", response.body
      end
    end
  end
end
