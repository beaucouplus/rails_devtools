# frozen_string_literal: true

module Devtools
  module Components
    class Lucide::Menu < Lucide::Base
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
          class: "lucide lucide-menu"
        ) do |s|
          s.line(x1: "4", x2: "20", y1: "12", y2: "12")
          s.line(x1: "4", x2: "20", y1: "6", y2: "6")
          s.line(x1: "4", x2: "20", y1: "18", y2: "18")
        end
      end
    end
  end
end
