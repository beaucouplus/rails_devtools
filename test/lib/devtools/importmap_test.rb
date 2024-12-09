require "test_helper"
module Devtools
  class ImportmapTest < ActiveSupport::TestCase
    test "importmap inherits from Importmaps::Base" do
      assert_kind_of(Devtools::Importmaps::Base, Devtools::Importmap.new)
    end
  end
end
