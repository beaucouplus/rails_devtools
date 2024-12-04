module Devtools
  class AssetResolver
    def path_to_asset(asset_name)
      base_paths = [
        Devtools::Engine.root.join("app", "javascript"),
        Devtools::Engine.root.join("vendor", "javascript")
      ]

      base_path = base_paths.find do |path|
        full_path = path.join(asset_name)
        File.file?(full_path)
      end

      raise "Asset not found: #{asset_name} in paths: #{base_paths.join(', ')}" unless base_path

      module_path = Pathname.new("/devtools").join("frontend", "modules")
      module_path.join(asset_name)
    end
  end
end
