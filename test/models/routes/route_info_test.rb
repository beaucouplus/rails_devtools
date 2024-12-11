require "test_helper"

class Devtools::Routes::RouteInfoTest < ActiveSupport::TestCase
  RouteDouble = Struct.new(:app, :path, :name, :defaults) do
    def spec
      path
    end
  end

  RouteWrapperDouble = Struct.new(:name, :path, :verb, :parts, :defaults) do
    def controller
      defaults[:controller]
    end

    def action
      defaults[:action]
    end

    def endpoint
      "UsersController#index"
    end

    def constraints
      {}
    end
  end

  RedirectApp = Struct.new(:status, :block) do
    def redirect?
      true
    end
  end

  AppWrapper = Struct.new(:app)

  def setup
    @route = RouteDouble.new(
      AppWrapper.new(ActionDispatch::Routing::RouteSet.new),
      "/users",
      "users",
      { controller: "users", action: "index" }
    )

    @wrapped_route = RouteWrapperDouble.new(
      "users",
      "/users",
      "GET",
      ["users", :format],
      { controller: "users", action: "index" }
    )

    ActionDispatch::Routing::RouteWrapper.stub(:new, @wrapped_route) do
      @route_info = Devtools::Routes::RouteInfo.new(@route)
    end
  end

  test "initializes with route and engine" do
    ActionDispatch::Routing::RouteWrapper.stub(:new, @wrapped_route) do
      route_info = Devtools::Routes::RouteInfo.new(@route)
      assert_equal "Application", route_info.engine_info.name
    end
  end

  test "delegates methods to wrapped route" do
    assert_equal "users", @route_info.controller
    assert_equal "index", @route_info.action
    assert_equal({}, @route_info.constraints)
    assert_equal "UsersController#index", @route_info.endpoint
  end

  test "returns segments without format" do
    assert_equal ["users"], @route_info.segments
  end

  test "determines route kind for controller route" do
    assert_equal "controller", @route_info.kind
    assert @route_info.controller?
  end

  test "determines route kind for rack app" do
    rack_app = Object.new
    def rack_app.call; end
    route = RouteDouble.new(
      AppWrapper.new(rack_app),
      "/users",
      nil,
      {}
    )

    ActionDispatch::Routing::RouteWrapper.stub(:new, @wrapped_route) do
      route_info = Devtools::Routes::RouteInfo.new(route)
      assert_equal "rack_app", route_info.kind
      assert route_info.rack_app?
    end
  end

  test "determines route kind for inline route" do
    inline_wrapped_route = @wrapped_route.dup
    def endpoint = "Proc/Lambda"

    ActionDispatch::Routing::RouteWrapper.stub(:new, inline_wrapped_route) do
      route_info = Devtools::Routes::RouteInfo.new(@route)
      assert_equal "inline", route_info.kind
      assert route_info.inline?
    end
  end

  test "determines route kind for redirection" do
    redirect_app = RedirectApp.new(301, -> { redirect_to "/" })
    route = RouteDouble.new(
      AppWrapper.new(redirect_app),
      "/users",
      nil,
      {}
    )

    ActionDispatch::Routing::RouteWrapper.stub(:new, @wrapped_route) do
      route_info = Devtools::Routes::RouteInfo.new(route)
      assert_equal "redirection", route_info.kind
      assert route_info.redirection?
    end
  end

  test "returns redirection info" do
    redirect_app = RedirectApp.new(301, -> { redirect_to "/" })
    route = RouteDouble.new(
      AppWrapper.new(redirect_app),
      "/users",
      nil,
      {}
    )

    ActionDispatch::Routing::RouteWrapper.stub(:new, @wrapped_route) do
      route_info = Devtools::Routes::RouteInfo.new(route)
      assert_equal 301, route_info.redirection_info.status
      assert_kind_of Proc, route_info.redirection_info.block
    end
  end

  test "returns verb for normal routes" do
    assert_equal "GET", @route_info.verb
  end

  test "returns ? for rack app routes" do
    rack_app = Object.new
    def rack_app.call; end
    route = RouteDouble.new(
      AppWrapper.new(rack_app),
      "/users",
      nil,
      {}
    )

    ActionDispatch::Routing::RouteWrapper.stub(:new, @wrapped_route) do
      route_info = Devtools::Routes::RouteInfo.new(route)
      assert_equal "?", route_info.verb
    end
  end

  test "returns ALL when no verb is specified" do
    no_verb_wrapped_route = RouteWrapperDouble.new(
      "users",
      "/users",
      nil,
      ["users", :format],
      { controller: "users", action: "index" }
    )

    ActionDispatch::Routing::RouteWrapper.stub(:new, no_verb_wrapped_route) do
      route_info = Devtools::Routes::RouteInfo.new(@route)
      assert_equal "ALL", route_info.verb
    end
  end
end
