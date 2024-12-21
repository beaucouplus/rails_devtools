# frozen_string_literal: true

module RailsDevtools
  class DatabaseTablesController < BaseController
    def index
      form = DatabaseTableSearchForm.new(search: form_params[:search])
      render DatabaseTables::Index.new(tables: form.results, form: form)
    end

    private

    def form_params
      params[:database_table_search_form] || { search: "" }
    end
  end
end
