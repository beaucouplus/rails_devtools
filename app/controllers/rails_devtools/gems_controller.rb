# frozen_string_literal: true

module RailsDevtools
  class GemsController < BaseController
    def index
      form = GemSearchForm.new(search: form_params[:search])
      render Gems::Index.new(gems: form.results, form: form)
    end

    private

    def form_params
      params[:gem_search_form] || { search: "" }
    end
  end
end
