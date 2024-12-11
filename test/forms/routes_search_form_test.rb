# frozen_string_literal: true

require "test_helper"

module Devtools
  class RoutesSearchFormTest < ActiveSupport::TestCase
    test "returns all routes when search is empty" do
      form = RoutesSearchForm.new(search: "")
      results = form.results

      assert_includes results.keys, "Application"
      assert results["Application"].any?, "Should have found application routes"
    end

    test "filters routes by search term" do
      form = RoutesSearchForm.new(search: "post")
      results = form.results

      assert_equal %w[post posts], results["Application"].map(&:name).sort
    end

    test "excludes rails internal routes" do
      form = RoutesSearchForm.new(search: "")
      results = form.results.values.flatten

      refute_includes results.map(&:name), "rails_info"
      refute_includes results.map(&:path), "/rails/info"
    end

    test "excludes turbo routes" do
      form = RoutesSearchForm.new(search: "")
      results = form.results.values.flatten

      refute_any results.map(&:name), ->(name) { name&.start_with?("turbo_") }
    end

    test "excludes devtools engine routes" do
      form = RoutesSearchForm.new(search: "")
      results = form.results

      refute_includes results.keys, "Devtools::Engine"
    end

    test "performs case-insensitive search" do
      form = RoutesSearchForm.new(search: "Post")
      results = form.results

      assert_equal %w[post posts], results["Application"].map(&:name).sort
    end

    private

    def refute_any(collection, predicate)
      refute collection.any?(&predicate), "Expected no elements to match the predicate"
    end
  end
end
