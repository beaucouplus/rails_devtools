# frozen_string_literal: true

module Devtools
  class DatabaseTableSearchForm
    include ActiveModel::Model

    DatabaseTable = Data.define(:table_name, :columns, :indexes)

    def initialize(search: "")
      @search = search.downcase
    end

    def results
      table_names = ActiveRecord::Base.connection.tables - ["schema_migrations", "ar_internal_metadata"]

      tables = table_names.map do |table|
        DatabaseTable.new(
          table_name: table,
          columns: ActiveRecord::Base.connection.columns(table),
          indexes: indexes(table)
        )
      end

      return tables if @search.empty?

      tables.select do |table|
        table.table_name.include?(@search) ||
          table.columns.any? { |column| column.name.include?(@search) }
      end
    end

    private

    ShortIndex = Data.define(:name, :columns, :unique)

    def indexes(table)
      indexes = ActiveRecord::Base.connection.indexes(table)
      indexes.map do |index|
        long_name = index.name
        prefix = "index_#{table}_on_"
        short_name = long_name.gsub(prefix, "").humanize

        ShortIndex.new(
          name: short_name,
          columns: index.columns,
          unique: index.unique
        )
      end
    end
  end
end
