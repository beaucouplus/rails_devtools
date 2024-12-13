require "test_helper"
require "bundler"

module Devtools
  class GemSearchFormTest < ActiveSupport::TestCase
    def setup
      @base_specs = [
        create_gem_info(name: "rails", groups: ["default"]),
        create_gem_info(name: "rspec-rails", groups: %w[development test]),
        create_gem_info(name: "factory_bot", groups: ["test"]),
        create_gem_info(name: "rubocop-rails", groups: ["development"])
      ]
    end

    test "empty search returns all gems ordered by group priority and name" do
      stub_bundler(@base_specs) do
        form = GemSearchForm.new(search: "")
        results = form.results

        expected_order = [
          "rails", # default (priority 0)
          "rubocop-rails", # development (priority 2)
          "rspec-rails",  # development-test (priority 3)
          "factory_bot"   # test (priority 4)
        ]

        assert_equal expected_order, results.map(&:name)
      end
    end

    test "search matches partial gem names" do
      stub_bundler(@base_specs) do
        form = GemSearchForm.new(search: "rails")
        results = form.results.map(&:name)

        assert_equal %w[rails rubocop-rails rspec-rails], results
        refute_includes results, "factory_bot"
      end
    end

    test "search is case insensitive" do
      stub_bundler(@base_specs) do
        form = GemSearchForm.new(search: "RAILS")
        results = form.results.map(&:name)

        assert_equal %w[rails rubocop-rails rspec-rails], results
      end
    end

    test "search with no matches returns empty array" do
      stub_bundler(@base_specs) do
        form = GemSearchForm.new(search: "nonexistent")
        results = form.results

        assert_empty results
      end
    end

    test "initializes with nil search parameter" do
      stub_bundler(@base_specs) do
        form = GemSearchForm.new
        results = form.results

        refute_empty results
      end
    end

    test "search maintains order within matched results" do
      specs = [
        create_gem_info(name: "rails", groups: ["default"]),
        create_gem_info(name: "rails-ujs", groups: ["production"]),
        create_gem_info(name: "rails-dom-testing", groups: ["development"]),
        create_gem_info(name: "test-rails", groups: ["test"])
      ]

      stub_bundler(specs) do
        form = GemSearchForm.new(search: "rails")
        results = form.results

        expected_order = [
          "rails", # default (priority 0)
          "rails-ujs",         # production (priority 1)
          "rails-dom-testing", # development (priority 2)
          "test-rails"         # test (priority 4)
        ]

        assert_equal expected_order, results.map(&:name)
      end
    end

    private

    def create_gem_info(attributes = {})
      defaults = {
        name: "example",
        required_version: "~> 1.0",
        actual_version: "1.0.0",
        homepage: "https://example.com",
        summary: "An example gem",
        source_code: "https://github.com/example/example",
        documentation: "https://example.com/docs",
        groups: ["default"],
        date: Time.current,
        latest_version: GemSearchForm::LatestSpec.new(version: "1.0.0", date: Time.current),
        changelog: "https://example.com/changelog"
      }

      GemSearchForm::GemInfo.new(**defaults.merge(attributes))
    end

    def stub_bundler(specs, &block)
      dependencies = specs.map do |spec|
        Struct.new(:name, :groups).new(spec.name, spec.groups)
      end

      bundle_specs = specs.map do |spec|
        Struct.new(:name, :version, :date, :requirements, :homepage, :summary, :metadata).new(
          spec.name,
          Gem::Version.new(spec.actual_version),
          spec.date,
          spec.required_version,
          spec.homepage,
          spec.summary,
          {
            "source_code_uri" => spec.source_code,
            "documentation_uri" => spec.documentation,
            "changelog_uri" => spec.changelog
          }
        )
      end

      bundle = Struct.new(:dependencies, :specs).new(dependencies, bundle_specs)

      Bundler.stub :load, bundle do
        specs.each do |spec|
          latest_spec = Struct.new(:version, :date).new(
            spec.latest_version.version,
            spec.latest_version.date
          )
          Gem.stub :latest_spec_for, latest_spec, [spec.name], &block
        end
      end
    end
  end
end
