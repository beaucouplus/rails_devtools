# frozen_string_literal: true

module RailsDevtools
  module Components
    class Lucide::Trash < Lucide::Base
      def view_template
        svg(
          xmlns: "http://www.w3.org/2000/svg",
          width: width,
          height: height,
          viewbox: "0 0 24 24",
          fill: "none",
          stroke: "currentColor",
          stroke_width: "2",
          stroke_linecap: "round",
          stroke_linejoin: "round",
          class: "lucide lucide-trash"
        ) do |s|
          s.path(d: "M3 6h18")
          s.path(d: "M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6")
          s.path(d: "M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2")
        end
      end
    end
  end
end
