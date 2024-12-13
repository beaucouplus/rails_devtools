require "test_helper"
require "minitest/autorun"
require "fastimage"

module Devtools
  module ImageAssets
    class ImageInfoTest < ActiveSupport::TestCase
      AssetConfig = Data.define(:paths, :implicit_path, :helper_snippet, :provider)

      def setup
        @base_path = Devtools::Engine.root.join("test/fixtures/files/images")
        @test_image_path = @base_path.join("squirrel.jpeg").to_s
        @image_info = ImageInfo.new(@test_image_path)
        @asset_config = AssetConfig.new(
          paths: [@base_path.to_s],
          implicit_path: "",
          helper_snippet: "image_tag",
          provider: :sprockets
        )
      end

      def stub_asset_config(&block)
        Devtools.stub(:asset_config, @asset_config) do
          block.call
        end
      end

      test "full_path return image path" do
        assert_equal @test_image_path, @image_info.full_path
      end

      test "valid? validates image path exists" do
        assert @image_info.valid?
      end

      test "valid? rejects invalid image path" do
        not_an_image_path = Devtools::Engine.root.join("test/fixtures/files/images/not_really_an_image.jpg").to_s
        image_info = ImageInfo.new(not_an_image_path)
        refute image_info.valid?
      end

      test "basename returns correct basename" do
        assert_equal "squirrel.jpeg", @image_info.basename
      end

      test "name returns correct name without extension" do
        assert_equal "squirrel", @image_info.name
      end

      test "file_size returns file size" do
        assert @image_info.file_size
      end

      test "devtools_image_path returns path to image without any asset pipeline magic" do
        stub_asset_config do
          assert_equal "squirrel.jpeg", @image_info.devtools_image_path
        end
      end

      test "devtools_image_path caches devtools image path" do
        stub_asset_config do
          first_call = @image_info.devtools_image_path
          second_call = @image_info.devtools_image_path

          assert_same first_call, second_call
        end
      end

      test "generates correct image helper snippet" do
        stub_asset_config do
          assert_equal "image_tag(\"squirrel.jpeg\")", @image_info.image_helper_snippet
        end
      end

      test "width and height return image dimensions" do
        FastImage.stub(:size, [800, 600]) do
          assert_equal 800, @image_info.width
          assert_equal 600, @image_info.height
        end
      end

      test "provider returns the provider from asset config" do
        stub_asset_config do
          assert_equal :sprockets, @image_info.provider
        end
      end
    end
  end
end
