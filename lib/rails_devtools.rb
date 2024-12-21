require "rails_devtools/version"
require "rails_devtools/engine"

module RailsDevtools
  def self.importmap
    @importmap ||= Importmap.new
  end

  def self.asset_config
    @asset_config ||= AssetConfig.find
  end
end

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/active_resource")
loader.setup

loader.eager_load
