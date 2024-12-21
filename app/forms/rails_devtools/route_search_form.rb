# frozen_string_literal: true

module RailsDevtools
  class RouteSearchForm
    include ActiveModel::Model

    def initialize(search: "")
      @search = search.downcase
    end

    def results
      Routes::Collection.all
        .select { |route| route.name.downcase.include?(@search) }
        .group_by { |route| route.engine_info.name }
    end
  end
end
