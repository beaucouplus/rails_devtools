# frozen_string_literal: true

module Devtools
  class Gems::Index < ApplicationView
    def initialize(form: nil, gems: [])
      @gems = gems
      @form = form
    end

    def view_template
      render Components::PageContent.new do |page|
        page.page_title { "Gems" }
        page.search_form(form: @form, path: helpers.gems_path)
        page.results { results }
      end
    end

    private

    def results
      if @gems.empty?
        div(class: "text-neutral") { "No results found" }
      else
        div(class: "w-full flex flex-col gap-y-2") do
          @gems.each do |gem|
            render Gems::GemCard.new(gem: gem)
          end
        end
      end
    end
  end
end
