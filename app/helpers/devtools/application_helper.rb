require "vite_rails/version"
require "vite_rails/tag_helpers"

module Devtools
  module ApplicationHelper
    include ::ViteRails::TagHelpers

    def vite_manifest
      Devtools::Engine.vite_ruby.manifest
    end
  end
end
