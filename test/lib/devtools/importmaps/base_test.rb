require "test_helper"
require "pathname"
require "json"

module Devtools
  module Importmaps
    class BaseTest < ActiveSupport::TestCase
      setup do
        # Clear pins before each test
        Base.instance_variable_set(:@pins, [])
      end

      test "pin method creates a pin with default options" do
        Base.pin("test_module")
        assert_equal 1, Base.pins.size
        pin = Base.pins.first
        assert_equal "test_module", pin.name
        assert_equal "test_module.js", pin.to
        assert_equal true, pin.preload
        assert_equal false, pin.vendor
      end

      test "pin method supports custom options" do
        Base.pin("custom_module", to: "custom.js", preload: false, vendor: true)
        pin = Base.pins.first
        assert_equal "custom_module", pin.name
        assert_equal "custom.js", pin.to
        assert_equal false, pin.preload
        assert_equal true, pin.vendor
      end

      test "pin_all_from method pins all JS files in a directory" do
        javascript_folder = Devtools::Engine.root.join("test/fixtures/files/javascript/controllers")

        Base.pin_all_from(javascript_folder, under: "test_modules")

        assert_equal 3, Base.pins.size

        index_pin = Base.pins.find { |pin| pin.name == "test_modules" }
        assert_equal "test_modules/index.js", index_pin.to

        module1_pin = Base.pins.find { |pin| pin.name == "test_modules/module1" }
        assert_equal "test_modules/module1.js", module1_pin.to

        module2_pin = Base.pins.find { |pin| pin.name == "test_modules/module2" }
        assert_equal "test_modules/module2.js", module2_pin.to
      end

      test "to_json method generates correct JSON" do
        Base.pin("module1", to: "module1.js")
        Base.pin("module2", to: "module2.js")

        base_instance = Base.new
        json_output = JSON.parse(base_instance.to_json)

        assert_equal({
                       "imports" => {
                         "module1" => "/devtools/frontend/modules/module1.js",
                         "module2" => "/devtools/frontend/modules/module2.js"
                       }
                     }, json_output)
      end

      test "find method returns correct pin" do
        Base.pin("module1", to: "module1.js")
        Base.pin("module2", to: "module2.js")

        base_instance = Base.new
        found_pin = base_instance.find("module1")

        assert_equal "module1.js", found_pin.to
      end

      test "preloads method returns only preloaded pins" do
        Base.pin("module1", to: "module1.js")
        Base.pin("module2", to: "module2.js", preload: false)

        base_instance = Base.new
        preloads = base_instance.preloads

        assert_equal 1, preloads.size
        assert_equal "module1.js", preloads.first.to
      end
    end

    class PinTest < ActiveSupport::TestCase
      setup do
        @engine_root = Devtools::Engine.root
        @pin = Pin.new("test_module", "test.js", true, false)
      end

      test "pin initialization sets correct attributes" do
        assert_equal "test_module", @pin.name
        assert_equal "test.js", @pin.to
        assert_equal true, @pin.preload
        assert_equal false, @pin.vendor
      end

      test "path method returns correct pathname" do
        expected_path = Pathname.new("/devtools/frontend/modules/test.js")
        assert_equal expected_path, @pin.path
      end

      test "file_path returns local file path when local javascript" do
        pin = Pin.new("local_module", "local_test.js", true, false)
        expected_path = @engine_root.join("app", "javascript", "local_test.js")
        assert_equal expected_path, pin.file_path
      end

      test "file_path returns vendor file path when vendor" do
        pin = Pin.new("vendor_module", "vendor_test.js", true, true)
        expected_path = @engine_root.join("vendor", "javascript", "vendor_test.js")
        assert_equal expected_path, pin.file_path
      end
    end
  end
end
