require "test_helper"
require "minitest/mock"

module RailsDevtools
  module AssetProviders
    class JsbundlingRailsConfigTest < ActiveSupport::TestCase
      test "provider returns :jsbundling_rails" do
        config = JsbundlingRailsConfig.new
        assert_equal :jsbundling_rails, config.provider
      end

      test "paths return Rails root javascript directory" do
        rails_root = Pathname.new("/mock/rails/root")
        Rails.stub(:root, rails_root) do
          config = JsbundlingRailsConfig.new
          assert_equal ["/mock/rails/root/app/javascript"], config.paths
        end
      end

      test "used? returns true when jsbundling-rails is in dependencies" do
        dependency = Minitest::Mock.new
        dependency.expect(:name, "jsbundling-rails")

        bundler_definition = Minitest::Mock.new
        bundler_definition.expect(:dependencies, [dependency])

        Bundler.stub(:definition, bundler_definition) do
          config = JsbundlingRailsConfig.new
          assert config.used?
        end

        dependency.verify
        bundler_definition.verify
      end

      test "used? returns false when jsbundling-rails is not in dependencies" do
        dependency = Minitest::Mock.new
        dependency.expect(:name, "some_other_gem")

        bundler_definition = Minitest::Mock.new
        bundler_definition.expect(:dependencies, [dependency])

        Bundler.stub(:definition, bundler_definition) do
          config = JsbundlingRailsConfig.new
          refute config.used?
        end

        dependency.verify
        bundler_definition.verify
      end
    end
  end
end
