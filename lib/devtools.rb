require "devtools/version"
require "devtools/engine"

module Devtools
  mattr_accessor :importmap, default: Importmap::Map.new

  def self.asset_config
    @asset_config ||= AssetConfig.find
  end
end

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/active_resource")
loader.setup

loader.eager_load
