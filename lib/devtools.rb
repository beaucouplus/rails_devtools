require "devtools/version"
require "devtools/engine"

module Devtools
  # Your code goes here...
end

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/active_resource")
loader.setup

loader.eager_load
