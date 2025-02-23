# frozen_string_literal: true

module RailsDevtools
  module Components
    class Lucide::Base < Components::ApplicationComponent
      attr_reader :width, :height, :stroke

      def initialize(width: 24, height: 24)
        @width = width.to_s
        @height = height.to_s
      end

      def view_template
        raise NotImplementedError, "You must implement the view_template method"
      end
    end
  end
end
