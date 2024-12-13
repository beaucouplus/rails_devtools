require "test_helper"

module Devtools
  class ImageSearchFormTest < ActiveSupport::TestCase
    def setup
      @fixtures_path = Devtools::Engine.root.join("test/fixtures/files/images")
      @config = Struct.new(:paths).new([@fixtures_path.to_s])
    end

    test "returns empty hash when no images match search term" do
      form = ImageSearchForm.new(search: "nonexistent")

      Devtools.stub(:asset_config, @config) do
        assert_empty form.results
      end
    end

    test "finds image with case-insensitive search" do
      form = ImageSearchForm.new(search: "SQUIRREL")

      Devtools.stub(:asset_config, @config) do
        results = form.results
        refute_empty results

        all_images = results.values.flatten
        assert(all_images.any? { |img| img.full_path.downcase.include?("squirrel") })
      end
    end

    test "finds all images with empty search" do
      form = ImageSearchForm.new(search: "")

      Devtools.stub(:asset_config, @config) do
        results = form.results

        all_images = results.values.flatten
        assert_equal 2, all_images.length
      end
    end

    test "skips invalid images" do
      form = ImageSearchForm.new(search: "not_really")

      Devtools.stub(:asset_config, @config) do
        results = form.results

        # The fixture not_really_an_image.jpg exists but isn't a valid image
        all_images = results.values.flatten
        refute(all_images.any? { |img| img.path.include?("not_really_an_image.jpg") })
      end
    end
  end
end
