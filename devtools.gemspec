require_relative "lib/devtools/version"

Gem::Specification.new do |spec|
  spec.name = "devtools"
  spec.version = Devtools::VERSION
  spec.authors = ["Maxime Souillat"]
  spec.email = ["maxime@beaucouplus.com"]
  spec.homepage = "https://github.com/beaucouplus/rails_devtools"
  spec.summary = "Devtools is a set of tools to help you develop your Rails application."
  spec.description = "Devtools is a set of tools to help you develop your Rails application."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.3.3"
end
