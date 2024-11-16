# frozen_string_literal: true

module Devtools
  module Routes
    class Index < ApplicationView
      def initialize(form: nil, routes: [])
        @routes = routes
        @form = form
      end

      def view_template
        render Components::PageContent.new do |page|
          page.page_title { "Routes" }
          page.search_form(form: @form, path: helpers.routes_path, method: :get)
          page.results { results }
        end
      end

      private

      def results
        if @routes.values.all? { |routes| routes.empty? }
          div(class: "text-neutral") { "No results found" }
        else
          div(class: "flex gap-2 flex-wrap w-full items-start") do
            @routes.each do |engine, routes|
              h3(class: "first:mt-0 mt-4 text-neutral opacity-75 text-lg") { engine }
              routes.each do |route|
                render Routes::RouteCard.new(route: route, engine: engine)
              end
            end
          end
        end
      end
    end
  end
end
