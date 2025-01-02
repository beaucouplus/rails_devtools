# frozen_string_literal: true

require_relative "lib/rails_devtools/version"

Gem::Specification.new do |spec|
  spec.name = "rails_devtools"
  spec.version = RailsDevtools::VERSION
  spec.licenses = ["MIT"]
  spec.required_ruby_version = ">= 3.0.0"

  spec.authors = ["Maxime Souillat"]
  spec.email = ["maxime@beaucouplus.com"]
  spec.homepage = "https://github.com/beaucouplus/rails_devtools"
  spec.summary = "Devtools is a set of tools to help you develop your Rails application."
  spec.description = "Devtools is a set of tools to help you develop your Rails application."

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib,vendor}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "fastimage", "~> 2.3", ">= 2.3.1"
  spec.add_dependency "phlex", "~> 1.11", ">= 1.11.0"
  spec.add_dependency "phlex-rails", "~> 1.1", ">= 1.1.2"
  spec.add_dependency "rails", ">= 7.1"
  spec.add_dependency "turbo-rails", "~> 2.0"
  spec.add_dependency "zeitwerk", "~> 2.6", ">= 2.6.12"

  spec.metadata["rubygems_mfa_required"] = "true"
end
