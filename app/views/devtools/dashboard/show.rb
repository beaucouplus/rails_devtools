# frozen_string_literal: true

module Devtools
  class Dashboard::Show < ApplicationView
    def initialize
      @title = "Rails Devtools"
    end

    def view_template
      content_for(:title) { @title }
      turbo_frame_tag(
        "page_content",
        src: helpers.database_tables_path,
        class: "flex flex-col gap-4"
      )
    end

    private
  end
end
