# frozen_string_literal: true

module RailsDevtools
  class DatabaseTables::Index < ApplicationView
    def initialize(form: nil, tables: [])
      @tables = tables
      @form = form
    end

    def view_template
      render Components::PageContent.new do |page|
        page.page_title { "Database tables" }
        page.search_form(form: @form, path: helpers.database_tables_path)
        page.results { results }
      end
    end

    private

    def results
      if @tables.empty?
        div(class: "text-neutral") { "No results found" }
      else
        div(class: "grid grid-cols-1 lg:grid-cols-2 2xl:grid-cols-3 3xl:grid-cols-4 gap-2 w-full items-start") do
          @tables.each do |table|
            render DatabaseTables::TableCard.new(table: table)
          end
        end
      end
    end
  end
end
