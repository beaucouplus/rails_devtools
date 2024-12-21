# frozen_string_literal: true

require "test_helper"

module RailsDevtools
  module Routes
    class CollectionTest < ActiveSupport::TestCase
      def setup
        @collection = Collection.new
      end

      test "all returns array of RouteInfo objects" do
        routes = Collection.all
        assert_instance_of Array, routes
        assert routes.all? { |route| route.is_a?(RouteInfo) }
      end

      test "find returns specific route by id" do
        all_routes = Collection.all
        first_route = all_routes.first
        found_route = Collection.find(first_route.id)

        assert_equal first_route.id, found_route.id
      end

      test "find returns nil for non-existent id" do
        assert_nil Collection.find(999)
      end

      test "all excludes rails routes" do
        routes = Collection.all
        assert routes.none? { |route| route.path.include?("rails/") }
        assert routes.none? { |route| route.name&.include?("rails") }
      end

      test "all excludes turbo routes" do
        routes = Collection.all
        assert routes.none? { |route| route.name&.start_with?("turbo") }
      end


      test "all includes application routes" do
        routes = Collection.all
        paths = routes.map(&:path)

        assert_includes paths, with_format("/posts")
        assert_includes paths, with_format("/posts/:id")
        assert_includes paths, with_format("/something_else")
        assert_includes paths, with_format("/redirect")
        assert_includes paths, with_format("/inline")
        assert_includes paths, with_format("/everything")
      end

      test "all includes engine routes" do
        routes = Collection.all
        assert routes.any? { |route| route.path.start_with?("/dummy_engine") }
      end

      test "all assigns sequential IDs to routes" do
        routes = Collection.all
        ids = routes.map(&:id)

        assert_equal ids, (1..ids.length).to_a
      end

      private

      def with_format(string)
        "#{string}(.:format)"
      end
    end
  end
end
