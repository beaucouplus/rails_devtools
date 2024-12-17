# frozen_string_literal: true

require "test_helper"

module Devtools
  class ImageAssetsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    
    def setup
      @source_image = File.join(Engine.root, "test/fixtures/files/images/squirrel.jpeg")
      @temp_image = File.join(Engine.root, "tmp/test_image.png")
      FileUtils.mkdir_p(File.dirname(@temp_image))
      FileUtils.cp(@source_image, @temp_image)
    end

    def teardown
      FileUtils.rm_f(@temp_image)
    end

    test "destroy removes image and redirects with flash notice for HTML format" do
      assert File.exist?(@temp_image), "Setup failed: temp image not created"
      
      delete image_asset_path("something", image_path: @temp_image)
      
      assert_redirected_to image_assets_path
      assert_equal "Image was successfully destroyed.", flash[:notice]
      refute File.exist?(@temp_image), "Image was not deleted"
    end

    test "destroy returns turbo stream response with remove and flash message" do
      assert File.exist?(@temp_image), "Setup failed: temp image not created"
      
      delete image_asset_path("something", image_path: @temp_image), 
        headers: { Accept: "text/vnd.turbo-stream.html" }
      
      assert_response :success
      assert_equal "text/vnd.turbo-stream.html", @response.media_type
      
      assert_match "turbo-stream", response.body
      assert_match "remove", response.body
      assert_match @temp_image, response.body
      assert_match "Image was successfully destroyed", response.body
      refute File.exist?(@temp_image), "Image was not deleted"
    end

    test "destroy raises error for invalid image" do
      assert_raises(RuntimeError, "This is a not an image") do
        delete image_asset_path("something", image_path: "test/fixtures/files/images/nonexistent.png")
      end
    end
  end
end
