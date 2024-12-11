require "test_helper"

module Devtools
  module Routes
    class ControllerInfoTest < ActiveSupport::TestCase
      def setup
        @controller_info = ControllerInfo.new(
          controller_name: "dummy",
          action: "index"
        )
      end

      test "returns correct file path" do
        assert_equal "dummy_controller.rb", @controller_info.file_path
      end

      test "returns correct full class name" do
        assert_equal "DummyController", @controller_info.full_class_name
      end

      test "returns action" do
        assert_equal "index", @controller_info.action
      end

      test "handles nil controller name" do
        info = ControllerInfo.new(controller_name: nil, action: "show")
        assert_equal "controller.rb", info.file_path
        assert_equal "Controller", info.full_class_name
      end

      test "handles nil action" do
        info = ControllerInfo.new(controller_name: "dummy", action: nil)
        assert_nil info.action
      end

      test "handles both nil values" do
        info = ControllerInfo.new(controller_name: nil, action: nil)
        assert_equal "controller.rb", info.file_path
        assert_equal "Controller", info.full_class_name
        assert_nil info.action
      end

      test "finds existing controller" do
        assert_equal DummyController, @controller_info.controller
      end

      test "returns nil for non-existent controller" do
        info = ControllerInfo.new(controller_name: "nonexistent")
        assert_nil info.controller
      end

      test "caches controller lookup" do
        first_result = @controller_info.controller
        assert_equal DummyController, first_result

        @controller_info.instance_variable_set("@controller_name", "nonexistent")
        assert_equal DummyController, @controller_info.controller
      end

      test "validates existing action" do
        assert @controller_info.action_exists?
      end

      test "invalidates non-existent action" do
        info = ControllerInfo.new(controller_name: "dummy", action: "nonexistent")
        refute info.action_exists?
      end

      test "action does not exist if controller not found" do
        info = ControllerInfo.new(controller_name: "nonexistent", action: "index")
        refute info.action_exists?
      end
    end
  end
end
