require "test_helper"

module Devtools
  module AssetProviders
    class ViteRailsConfigTest < ActiveSupport::TestCase
      setup do
        @config = ViteRailsConfig.new
      end

      test "provider returns :vite_rails symbol" do
        assert_equal :vite_rails, @config.provider
      end

      test "paths returns array with frontend directory path" do
        expected_path = Rails.root.join("app/frontend").to_s

        assert_equal [expected_path], @config.paths
      end

      test "used? returns true when vite.json exists" do
        path_mock = Minitest::Mock.new
        path_mock.expect(:exist?, true)

        rails_root = Minitest::Mock.new
        rails_root.expect(:join, path_mock, ["config/vite.json"])

        Rails.stub(:root, rails_root) do
          assert @config.used?
        end

        path_mock.verify
        rails_root.verify
      end

      test "used? returns false when vite.json does not exist" do
        path_mock = Minitest::Mock.new
        path_mock.expect(:exist?, false)

        rails_root = Minitest::Mock.new
        rails_root.expect(:join, path_mock, ["config/vite.json"])

        Rails.stub(:root, rails_root) do
          assert_not @config.used?
        end

        path_mock.verify
        rails_root.verify
      end
    end
  end
end
