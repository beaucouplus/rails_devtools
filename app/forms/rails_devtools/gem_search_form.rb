# frozen_string_literal: true

module RailsDevtools
  class GemSearchForm
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
        return false if latest_version.nil?

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
          latest_version: latest_spec ? LatestSpec.new(version: latest_spec.version, date: latest_spec.date) : nil,
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
  end
end
