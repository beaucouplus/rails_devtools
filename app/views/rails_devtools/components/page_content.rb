# frozen_string_literal: true

module RailsDevtools
  module Components
    class PageContent < Components::ApplicationComponent
      def view_template(&block)
        turbo_frame_tag("page_content", &block)
      end

      def page_title(&block)
        content_for(:title) { "Rails Devtools - #{block.call}" }
        h1(class: "text-2xl font-bold", &block)
      end

      def search_form(form:, path:, method: :get)
        render Components::Ui::SearchForm.new(
          form: form,
          path: path,
          method: method
        )
      end

      def results(&block)
        div(class: "mt-4", &block)
      end
    end
  end
end
