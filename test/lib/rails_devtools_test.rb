require "test_helper"

class DevtoolsTest < ActiveSupport::TestCase
  test "importmap returns an instance of importmap" do
    assert_instance_of(RailsDevtools::Importmap, RailsDevtools.importmap)
  end

  test "asset_config returns a list of asset configurations" do
    assert_instance_of(RailsDevtools::AssetConfig, RailsDevtools.asset_config)
  end
end
