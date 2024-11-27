# frozen_string_literal: true

module Devtools
  class GemsSearchForm
    include ActiveModel::Model

    GemInfo = Data.define(
      :name,
      :required_version,
      :actual_version,
      :homepage,
      :summary,
      :source_code,
      :documentation,
      :groups,
      :date,
      :latest_version,
      :changelog
    ) do
      def outdated?
        actual_version < latest_version.version
      end
    end

    def initialize(search: "")
      @search = search.downcase
    end

    def results
      specs = ask_bundler_for_specs
      gems_list = specs.map { |gem_spec| GemInfo.new(**gem_spec) }

      return order(gems_list) if @search.empty?

      order(
        gems_list.select { |gem| gem.name.include?(@search) }
      )
    end

    private

    GROUP_PRIORITY = {
      "default" => 0,
      "production" => 1,
      "development" => 2,
      "development-test" => 3,
      "test" => 4
    }.freeze

    def order(gems)
      gems.sort_by do |item|
        [GROUP_PRIORITY.fetch(item.groups.join("-"), 5), item.name]
      end
    end

    LatestSpec = Data.define(:version, :date)

    def ask_bundler_for_specs
      bundle = Bundler.load

      dependencies = bundle.dependencies.map { |dep| [dep.name, dep.groups] }.to_h
      specs = bundle.specs.select do |spec|
        dependencies.keys.include?(spec.name)
      end

      specs.map do |spec|
        latest_spec = Gem.latest_spec_for(spec.name)
        {
          name: spec.name,
          latest_version: LatestSpec.new(version: latest_spec.version, date: latest_spec.date),
          date: spec.date,
          required_version: spec.requirements.to_s,
          actual_version: spec.version.to_s,
          homepage: spec.homepage,
          summary: spec.summary,
          source_code: spec.metadata["source_code_uri"],
          documentation: spec.metadata["documentation_uri"],
          changelog: spec.metadata["changelog_uri"],
          groups: dependencies[spec.name]
        }
      end
    end

    def last_gemfile_commit
      return @last_gemfile_commit if defined?(@last_gemfile_commit)

      last_commit = `git log -n 1 --pretty=format:%H -- #{Rails.root.join("Gemfile")}`.strip
      return if last_commit.empty?

      @last_gemfile_commit = last_commit
    end
  end
end
