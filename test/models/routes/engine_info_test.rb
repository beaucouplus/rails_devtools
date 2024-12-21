require "test_helper"

class RailsDevtools::Routes::EngineInfoTest < ActiveSupport::TestCase
  EngineRoutes = Struct.new(:routes) do
    def find_script_name(_)
      "/super/admin"
    end
  end

  test "identifies Rails application" do
    engine_info = RailsDevtools::Routes::EngineInfo.new("Application")
    assert_equal Rails.application, engine_info.engine
    refute engine_info.engine?
  end

  test "handles mounted engine" do
    engine_class = Class.new do
      def self.routes
        EngineRoutes.new([])
      end
    end
    Object.const_set("AdminEngine", engine_class)

    engine_info = RailsDevtools::Routes::EngineInfo.new("AdminEngine")
    assert engine_info.engine?
    assert_equal "/super/admin", engine_info.path
    assert_equal "admin", engine_info.helper_prefix

    Object.send(:remove_const, "AdminEngine")
  end

  test "returns empty path for application" do
    engine_info = RailsDevtools::Routes::EngineInfo.new("Application")
    Rails.application.routes.stub(:find_script_name, "") do
      assert_equal "", engine_info.path
    end
  end

  test "returns empty helper prefix for application" do
    engine_info = RailsDevtools::Routes::EngineInfo.new("Application")
    assert_equal "", engine_info.helper_prefix
  end
end
