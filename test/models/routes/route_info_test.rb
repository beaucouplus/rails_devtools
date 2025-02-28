# frozen_string_literal: true

require "test_helper"

module RailsDevtools
  class Routes::RouteInfoTest < ActiveSupport::TestCase
    setup do
      @route = Rails.application.routes.routes.find { |r| r.name == "post" }
      @route_info = RailsDevtools::Routes::RouteInfo.new(@route, id: 1)
    end

    test "initializes with route and engine" do
      route_info = RailsDevtools::Routes::RouteInfo.new(@route, id: 1)
      assert_equal "Application", route_info.engine_info.name
    end

    test "delegates methods to wrapped route" do
      assert_equal "posts", @route_info.controller
      assert_equal "show", @route_info.action
      assert_empty @route_info.constraints
      assert_equal "posts#show", @route_info.endpoint
    end

    test "returns segments without format" do
      assert_equal [:id], @route_info.segments
    end

    test "determines route kind for controller route" do
      assert_equal "controller", @route_info.kind
      assert @route_info.controller?
    end

    test "determines route kind for inline route" do
      route = Rails.application.routes.routes.find { |r| r.name == "inline" }
      route_info = RailsDevtools::Routes::RouteInfo.new(route, id: 1)

      assert_equal "inline", route_info.kind
      assert route_info.inline?
    end

    test "determines route kind for engine" do
      route = Rails.application.routes.routes.find { |r| r.name == "rails_devtools" }
      route_info = RailsDevtools::Routes::RouteInfo.new(route, id: 1)

      assert_equal "engine", route_info.kind
      assert route_info.engine?
    end

    test "determines route kind for redirection" do
      route = Rails.application.routes.routes.find { |r| r.name == "redirect" }
      route_info = RailsDevtools::Routes::RouteInfo.new(route, id: 1)

      assert_equal "redirection", route_info.kind
      assert route_info.redirection?
    end

    test "returns redirection info" do
      route = Rails.application.routes.routes.find { |r| r.name == "redirect" }
      route_info = RailsDevtools::Routes::RouteInfo.new(route, id: 1)

      assert_equal 301, route_info.redirection_info.status
      assert_equal "/something_else", route_info.redirection_info.block
    end

    test "returns verb for normal routes" do
      assert_equal "GET", @route_info.verb
    end

    test "verb returns ? for engines" do
      route = Rails.application.routes.routes.find { |r| r.name == "rails_devtools" }
      route_info = RailsDevtools::Routes::RouteInfo.new(route, id: 1)

      assert_equal "?", route_info.verb
    end

    test "verb returns ALL when no verb is specified" do
      route = Rails.application.routes.routes.find { |r| r.name == "everything" }
      route_info = RailsDevtools::Routes::RouteInfo.new(route, id: 1)

      assert_equal "ALL", route_info.verb
    end
  end
end
