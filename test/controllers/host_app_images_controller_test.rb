# frozen_string_literal: true

require "test_helper"

module RailsDevtools
  class HostAppImagesControllerTest < ActionDispatch::IntegrationTest
    include RailsDevtools::Engine.routes.url_helpers
    def setup
      @routes = RailsDevtools::Engine.routes
    end

    def with_stubbed_paths(&block)
      fixture_path = RailsDevtools::Engine.root.join("test/fixtures/files/images")
      RailsDevtools.asset_config.stub(:paths, [fixture_path]) do
        block.call
      end
    end

    test "show returns image with correct mime type for jpeg" do
      with_stubbed_paths do
        get host_app_image_path(path: "squirrel", format: "jpeg")

        assert_response :success
        assert_equal "image/jpeg", response.content_type
        assert_includes response.headers["Content-Disposition"], "inline"
      end
    end

    test "show returns 404 for non-image format" do
      with_stubbed_paths do
        get host_app_image_path(path: "example", format: "txt")
        assert_response :not_found
      end
    end

    test "show returns 404 when image not found" do
      with_stubbed_paths do
        get host_app_image_path(path: "nonexistent", format: "png")

        assert_response :not_found
      end
    end
  end
end
