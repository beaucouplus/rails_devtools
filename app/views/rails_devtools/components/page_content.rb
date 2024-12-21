# frozen_string_literal: true

module RailsDevtools
  module Components
    class PageContent < Components::ApplicationComponent
      def view_template(&)
        turbo_frame_tag("page_content", &)
      end

      def page_title(&)
        h1(class: "text-2xl font-bold", &)
      end

      def search_form(form:, path:, method: :get)
        render Components::Ui::SearchForm.new(
          form: form,
          path: path,
          method: method
        )
      end

      def results(&)
        div(class: "mt-4", &)
      end
    end
  end
end
