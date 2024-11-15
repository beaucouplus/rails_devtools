module Devtools
  module Components
    class Lucide::Close < Lucide::Base
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
          class: "lucide lucide-x"
        ) do |s|
          s.path(d: "M18 6 6 18")
          s.path(d: "m6 6 12 12")
        end
      end
    end
  end
end
