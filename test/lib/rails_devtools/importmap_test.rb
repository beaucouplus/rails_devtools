require "test_helper"
module RailsDevtools
  class ImportmapTest < ActiveSupport::TestCase
    test "importmap inherits from Importmaps::Base" do
      assert_kind_of(RailsDevtools::Importmaps::Base, RailsDevtools::Importmap.new)
    end
  end
end
