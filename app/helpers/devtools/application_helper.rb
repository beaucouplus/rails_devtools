module Devtools
  module ApplicationHelper
    def devtools_importmap_tags(entry_point = "application", importmap: Devtools.importmap)
      safe_join [
        javascript_inline_importmap_tag(importmap.to_json(resolver: Devtools::AssetResolver.new)),
        javascript_importmap_module_preload_tags(importmap),
        javascript_import_module_tag(entry_point)
      ].compact, "\n"
    end
  end
end
