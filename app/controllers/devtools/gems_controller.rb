# frozen_string_literal: true

module Devtools
  class GemsController < BaseController
    def index
      form = GemsSearchForm.new(search: form_params[:search])
      render Gems::Index.new(gems: form.results, form: form)
    end

    private

    def form_params
      params[:gems_search_form] || { search: "" }
    end
  end
end
