# frozen_string_literal: true

module RailsDevtools
  class DatabaseTables::TableCard < Components::ApplicationComponent
    def initialize(table:)
      @table = table
    end

    def view_template
      div(class: "card bg-white text-sm w-full shadow-sm") do
        div(class: "card-body") do
          h2(class: "card-title") { @table.table_name.capitalize }
          columns_list
          indexes_list
        end
      end
    end

    private

    def columns_list
      div(class: "flex flex-col gap-2 divide-y divide-base-200") do
        @table.columns.each do |column|
          div(class: "flex gap-x-2 text-neutral pt-2 justify-between items-center") do
            div(class: "flex gap-x-2") do
              div(class: "font-bold") { column.name }
              div(class: "text-neutral italic") { column.type }
            end
            span(class: "text-xs opacity-75") { column.default } if column.default
            div(class: "text-xs opacity-75") { "not null" } unless column.null
          end
        end
      end
    end

    def indexes_list
      div(class: "mt-8") do
        h3(class: "text-lg font-bold") { "#{@table.table_name.capitalize} indexes" }
        div(class: "mt-2 flex flex-col gap-2 divide-y divide-base-200") do
          @table.indexes.each do |index|
            div(class: "flex gap-x-2 text-neutral pt-2 justify-between items-center") do
              div do
                div(class: "font-bold") { index.name }
                div(class: "text-xs opacity-75") do
                  [index.unique ? "unique" : nil, index_columns_text(index.columns)].compact.join(" ")
                end
              end
            end
          end
        end
      end
    end

    def index_columns_text(columns)
      columns = Array(columns)
      return columns.first if columns.one?

      "composite of #{columns.join(", ")}"
    end
  end
end
