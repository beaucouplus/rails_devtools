require "test_helper"
require "yaml"
require "set"

module RailsDevtools
  module AssetProviders
    class ShakapackerConfigTest < ActiveSupport::TestCase
      setup do
        @rails_root = Pathname.new("/mock/rails/root")
        @config_path = @rails_root.join("config", "shakapacker.yml")
      end

      test "provider returns :shakapacker" do
        config = ShakapackerConfig.new
        assert_equal :shakapacker, config.provider
      end

      test "paths returns source path and additional paths" do
        mock_config = {
          "source_path" => "/mock/source/path",
          "additional_paths" => ["/mock/additional/path1", "/mock/additional/path2"]
        }

        Rails.stub(:root, @rails_root) do
          YAML.stub(:load_file, mock_config) do
            config = ShakapackerConfig.new
            expected_paths = ["/mock/source/path", "/mock/additional/path1", "/mock/additional/path2"]
            assert_equal expected_paths, config.paths
          end
        end
      end

      test "paths handles config with no additional paths" do
        mock_config = {
          "source_path" => "/mock/source/path",
          "additional_paths" => []
        }

        Rails.stub(:root, @rails_root) do
          YAML.stub(:load_file, mock_config) do
            config = ShakapackerConfig.new
            expected_paths = ["/mock/source/path"]
            assert_equal expected_paths, config.paths
          end
        end
      end

      test "paths memoizes result" do
        mock_config = {
          "source_path" => "/mock/source/path",
          "additional_paths" => ["/mock/additional/path"]
        }

        Rails.stub(:root, @rails_root) do
          YAML.stub(:load_file, mock_config) do
            config = ShakapackerConfig.new
            first_result = config.paths
            second_result = config.paths
            assert_same first_result, second_result
          end
        end
      end

      test "used? returns true when shakapacker.yml exists" do
        path_mock = Minitest::Mock.new
        path_mock.expect(:exist?, true)

        joined_path = Pathname.new(@rails_root).join("config", "shakapacker.yml")
        Pathname.stub(:new, joined_path) do
          Rails.stub(:root, @rails_root) do
            joined_path.stub(:exist?, true) do
              config = ShakapackerConfig.new
              assert config.used?
            end
          end
        end
      end

      test "used? returns false when shakapacker.yml does not exist" do
        Rails.stub(:root, @rails_root) do
          @config_path.stub(:exist?, false) do
            config = ShakapackerConfig.new
            refute config.used?
          end
        end
      end
    end
  end
end
