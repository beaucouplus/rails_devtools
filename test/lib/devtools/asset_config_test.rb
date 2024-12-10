require "test_helper"

module Devtools
  class AssetConfigTest < ActiveSupport::TestCase
    class MockProvider
      attr_reader :provider, :paths

      def initialize(provider, paths)
        @provider = provider
        @paths = paths
      end
    end

    setup do
      @sprockets_provider = MockProvider.new(:sprockets, ["/path/to/sprockets/images"])
      @vite_provider = MockProvider.new(:vite_rails, ["/path/to/vite/assets"])
    end

    test ".find creates instance with providers from AssetProvider" do
      provider_list = [@sprockets_provider]
      asset_provider = Minitest::Mock.new
      asset_provider.expect(:list, provider_list)

      AssetProvider.stub(:new, asset_provider) do
        config = AssetConfig.find
        assert_equal ["/path/to/sprockets/images"], config.paths
      end

      asset_provider.verify
    end

    test "#paths returns flattened array of all provider paths" do
      config = AssetConfig.new([@sprockets_provider, @vite_provider])
      expected_paths = ["/path/to/sprockets/images", "/path/to/vite/assets"]

      assert_equal expected_paths, config.paths
    end

    test "#paths memoizes the result" do
      config = AssetConfig.new([@sprockets_provider])
      first_call = config.paths

      @sprockets_provider.define_singleton_method(:paths) { raise "Should not be called again" }

      assert_equal first_call, config.paths
    end

    test "#helper_snippet returns 'vite_image_tag' when vite_rails is present" do
      config = AssetConfig.new([@vite_provider])
      assert_equal "vite_image_tag", config.helper_snippet
    end

    test "#helper_snippet returns 'image_tag' when vite_rails is not present" do
      config = AssetConfig.new([@sprockets_provider])
      assert_equal "image_tag", config.helper_snippet
    end

    test "#implicit_path returns empty string when vite_rails is present" do
      config = AssetConfig.new([@vite_provider])
      assert_equal "", config.implicit_path
    end

    test "#implicit_path returns 'images/' when vite_rails is not present" do
      config = AssetConfig.new([@sprockets_provider])
      assert_equal "images/", config.implicit_path
    end

    test "#vite_rails? returns true when vite_rails provider is present" do
      config = AssetConfig.new([@vite_provider])
      assert config.vite_rails?
    end

    test "#vite_rails? returns false when vite_rails provider is not present" do
      config = AssetConfig.new([@sprockets_provider])
      assert_not config.vite_rails?
    end
  end

  class AssetProviderTest < ActiveSupport::TestCase
    class MockConfig
      def initialize(used)
        @used = used
      end

      def used?
        @used
      end
    end

    test "#list returns only providers that are used" do
      used_provider = Class.new do
        def self.new
          MockConfig.new(true)
        end
      end

      unused_provider = Class.new do
        def self.new
          MockConfig.new(false)
        end
      end

      stub_const(AssetProvider, :PROVIDERS, [used_provider, unused_provider]) do
        provider = AssetProvider.new
        providers = provider.list

        assert_equal 1, providers.length
        assert_instance_of MockConfig, providers.first
      end
    end

    test "#list memoizes the result" do
      provider = AssetProvider.new
      first_result = provider.list

      error_provider = Class.new do
        def self.new
          raise "Should not be called"
        end
      end

      stub_const(AssetProvider, :PROVIDERS, [error_provider]) do
        assert_equal first_result, provider.list
      end
    end

    private

    def stub_const(owner, const_name, temp_value)
      original_value = owner.const_get(const_name)
      owner.send(:remove_const, const_name)
      owner.const_set(const_name, temp_value)
      yield
    ensure
      owner.send(:remove_const, const_name)
      owner.const_set(const_name, original_value)
    end
  end
end
