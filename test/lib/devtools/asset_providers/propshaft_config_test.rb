require "test_helper"
require "minitest/mock"

module Devtools
  module AssetProviders
    class PropshaftConfigTest < ActiveSupport::TestCase
      test "provider returns :propshaft" do
        config = PropshaftConfig.new
        assert_equal :propshaft, config.provider
      end

      test "paths returns image paths from Rails assets configuration" do
        image_path1 = Pathname.new("/mock/app/assets/images")
        image_path2 = Pathname.new("/mock/vendor/assets/images")
        non_image_path = Pathname.new("/mock/app/assets/javascripts")

        mock_app = Minitest::Mock.new
        mock_config = Minitest::Mock.new

        mock_app.expect(:config, mock_config)
        mock_config.expect(:assets, mock_config)
        mock_config.expect(:paths, [image_path1.to_s, non_image_path.to_s, image_path2.to_s])

        Rails.stub(:application, mock_app) do
          config = PropshaftConfig.new
          assert_equal [image_path1.to_s, image_path2.to_s], config.paths
        end

        mock_app.verify
        mock_config.verify
      end

      test "used? returns true when Propshaft is defined" do
        # Only remove if defined to avoid errors
        Object.send(:remove_const, :Propshaft) if defined?(Propshaft)

        # Define Propshaft temporarily
        Object.const_set(:Propshaft, Module.new)

        config = PropshaftConfig.new
        assert config.used?

        # Clean up
        Object.send(:remove_const, :Propshaft)
      end

      test "used? returns false when Propshaft is not defined" do
        # Ensure Propshaft is not defined
        Object.send(:remove_const, :Propshaft) if defined?(Propshaft)

        config = PropshaftConfig.new
        refute config.used?
      end
    end
  end
end
