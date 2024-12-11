require "test_helper"
require "minitest/autorun"
require "fastimage"

module Devtools
  module ImageAssets
    class ImageInfoTest < ActiveSupport::TestCase
      AssetConfig = Data.define(:paths, :implicit_path, :helper_snippet, :provider)
      FastImageData = Struct.new(:content_length)

      def setup
        @test_image_path = "/app/assets/images/test/sample.jpg"
        @image_info = ImageInfo.new(@test_image_path)
      end

      test "initializes with image path" do
        assert_equal @test_image_path, @image_info.full_path
      end

      test "validates image path exists" do
        File.stub(:file?, true) do
          assert @image_info.valid?
        end

        File.stub(:file?, false) do
          refute @image_info.valid?
        end
      end

      test "validates image extensions" do
        [".jpg", ".jpeg", ".png", ".gif", ".webp", ".svg", ".avif", ".ico"].each do |ext|
          image_info = ImageInfo.new("test#{ext}")
          assert image_info.image?(image_info.full_path), "Should accept #{ext} extension"
        end

        image_info = ImageInfo.new("test.txt")
        refute image_info.image?(image_info.full_path), "Should reject non-image extension"
      end

      test "returns correct basename" do
        assert_equal "sample.jpg", @image_info.basename
      end

      test "returns correct name without extension" do
        assert_equal "sample", @image_info.name
      end

      test "returns lowercase extension" do
        image_info = ImageInfo.new("test.JPG")
        assert_equal ".jpg", image_info.extension
      end

      test "gets file size" do
        FastImage.stub(:new, FastImageData.new(1024)) do
          assert_equal 1024, @image_info.file_size
        end
      end

      test "generates correct image helper snippet" do
        asset_config = AssetConfig.new(
          paths: [],
          implicit_path: "",
          helper_snippet: "image_tag",
          provider: nil
        )

        Devtools.stub(:asset_config, asset_config) do
          @image_info.stub(:devtools_image_path, "test/sample.jpg") do
            assert_equal "image_tag(\"test/sample.jpg\")", @image_info.image_helper_snippet
          end
        end
      end

      test "calculates devtools image path" do
        asset_config = AssetConfig.new(
          paths: ["/app/assets"],
          implicit_path: "images",
          helper_snippet: nil,
          provider: nil
        )

        Devtools.stub(:asset_config, asset_config) do
          assert_equal "test/sample.jpg", @image_info.devtools_image_path
        end
      end

      test "gets image dimensions" do
        FastImage.stub(:size, [800, 600]) do
          assert_equal 800, @image_info.width
          assert_equal 600, @image_info.height
        end
      end

      test "delegates provider to asset config" do
        asset_config = AssetConfig.new(
          paths: [],
          implicit_path: "",
          helper_snippet: nil,
          provider: "local"
        )

        Devtools.stub(:asset_config, asset_config) do
          assert_equal "local", @image_info.provider
        end
      end

      test "caches devtools image path" do
        asset_config = AssetConfig.new(
          paths: ["/app/assets"],
          implicit_path: "images",
          helper_snippet: nil,
          provider: nil
        )

        Devtools.stub(:asset_config, asset_config) do
          first_call = @image_info.devtools_image_path
          second_call = @image_info.devtools_image_path

          assert_equal first_call, second_call
          assert_equal "test/sample.jpg", first_call
        end
      end
    end
  end
end
