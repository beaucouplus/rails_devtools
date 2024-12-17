# frozen_string_literal: true

require "test_helper"

module Devtools
  class RouteSearchFormTest < ActiveSupport::TestCase
    test "returns all routes when search is empty" do
      form = RouteSearchForm.new(search: "")
      results = form.results

      assert_includes results.keys, "Application"
      assert results["Application"].any?, "Should have found application routes"
    end

    test "filters routes by search term" do
      form = RouteSearchForm.new(search: "post")
      results = form.results

      assert_equal %w[post posts], results["Application"].map(&:name).sort
    end

    test "performs case-insensitive search" do
      form = RouteSearchForm.new(search: "Post")
      results = form.results

      assert_equal %w[post posts], results["Application"].map(&:name).sort
    end
  end
end
