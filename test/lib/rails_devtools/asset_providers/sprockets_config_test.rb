require "test_helper"

module RailsDevtools
  module AssetProviders
    class SprocketConfigTest < ActiveSupport::TestCase
      # Test double for Rails configuration
      class MockRailsConfig
        def initialize(responds_to_assets)
          @responds_to_assets = responds_to_assets
        end

        def respond_to?(method_name)
          method_name == :assets && @responds_to_assets
        end
      end

      setup do
        @config = SprocketConfig.new
      end

      test "provider returns :sprockets symbol" do
        assert_equal :sprockets, @config.provider
      end

      test "paths returns only image paths from Rails assets" do
        # Setup mock paths
        image_path1 = Rails.root.join("app/assets/images").to_s
        image_path2 = Rails.root.join("lib/assets/images").to_s
        js_path = Rails.root.join("app/assets/javascripts").to_s
        css_path = Rails.root.join("app/assets/stylesheets").to_s
        mock_paths = [image_path1, image_path2, js_path, css_path]

        # Create mock Rails config
        rails_config = Minitest::Mock.new
        rails_assets = Minitest::Mock.new
        rails_application = Minitest::Mock.new

        rails_assets.expect(:paths, mock_paths)
        rails_config.expect(:assets, rails_assets)
        rails_application.expect(:config, rails_config)

        Rails.stub(:application, rails_application) do
          result = @config.paths

          assert_equal 2, result.length
          assert_includes result, image_path1
          assert_includes result, image_path2
          refute_includes result, js_path
          refute_includes result, css_path
        end

        rails_assets.verify
        rails_config.verify
        rails_application.verify
      end

      test "paths returns empty array when no image paths exist" do
        # Setup mock with no image paths
        mock_paths = [
          Rails.root.join("app/assets/javascripts").to_s,
          Rails.root.join("app/assets/stylesheets").to_s
        ]

        # Create mock Rails config
        rails_config = Minitest::Mock.new
        rails_assets = Minitest::Mock.new
        rails_application = Minitest::Mock.new

        rails_assets.expect(:paths, mock_paths)
        rails_config.expect(:assets, rails_assets)
        rails_application.expect(:config, rails_config)

        Rails.stub(:application, rails_application) do
          assert_empty @config.paths
        end

        rails_assets.verify
        rails_config.verify
        rails_application.verify
      end

      test "used? returns true when Rails.application.config responds to assets" do
        rails_application = Object.new
        def rails_application.config
          MockRailsConfig.new(true)
        end

        Rails.stub(:application, rails_application) do
          assert @config.used?
        end
      end

      test "used? returns false when Rails.application.config does not respond to assets" do
        rails_application = Object.new
        def rails_application.config
          MockRailsConfig.new(false)
        end

        Rails.stub(:application, rails_application) do
          assert_not @config.used?
        end
      end
    end
  end
end
