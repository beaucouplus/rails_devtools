require "test_helper"

class DevtoolsTest < ActiveSupport::TestCase
  test "importmap returns an instance of importmap" do
    assert_instance_of(Devtools::Importmap, Devtools.importmap)
  end

  test "asset_config returns a list of asset configurations" do
    assert_instance_of(Devtools::AssetConfig, Devtools.asset_config)
  end
end
