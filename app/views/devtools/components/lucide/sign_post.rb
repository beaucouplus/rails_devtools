# frozen_string_literal: true

module Devtools
  module Components
    class Lucide::SignPost < Lucide::Base
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
          class: "lucide lucide-signpost"
        ) do |s|
          s.path(d: "M12 13v8")
          s.path(d: "M12 3v3")
          s.path(
            d:
              "M18 6a2 2 0 0 1 1.387.56l2.307 2.22a1 1 0 0 1 0 1.44l-2.307 2.22A2 2 0 0 1 18 13H6a2 2 0 0 1-1.387-.56l-2.306-2.22a1 1 0 0 1 0-1.44l2.306-2.22A2 2 0 0 1 6 6z"
          )
        end
      end
    end
  end
end
