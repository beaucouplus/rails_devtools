# frozen_string_literal: true

module RailsDevtools
  class Gems::GemCard < Components::ApplicationComponent
    include Phlex::Rails::Helpers::DistanceOfTimeInWords

    def initialize(gem:)
      @gem = gem
    end

    def view_template
      div(class: "card card-compact bg-white text-sm w-full shadow-sm") do
        div(class: "card-body") do
          div(class: "card-actions") do
            @gem.groups.each do |group|
              div(class: "badge badge-sm") { group }
            end
          end
          h2(class: "inline-flex card-title justify-between items-center") do
            div(class: "flex items-center gap-2") do
              span do
                [@gem.name.titleize.capitalize, @gem.actual_version].join(" ")
              end
              span(class: "badge badge-sm badge-warning font-normal") { "outdated" } if @gem.outdated?
            end
            span(class: "text-sm text-neutral opacity-75 font-normal") do
              @gem.date.strftime("%b %d, %Y")
            end
          end

          div(class: "text-neutral opacity-75") do
            outdated_info
            div { @gem.summary }
          end
          div(class: "card-actions mt-4 justify-end") do
            if @gem.source_code
              a(href: @gem.source_code, class: "btn btn-xs btn-outline btn-secondary") do
                "Source Code"
              end
            end
            if @gem.documentation
              a(href: @gem.documentation, class: "btn btn-xs btn-outline btn-secondary") do
                "Documentation"
              end
            end
            a(href: @gem.homepage, class: "btn btn-xs") { "Homepage" } if @gem.homepage
          end
        end
      end
    end

    private

    def outdated_info
      return unless @gem.outdated?

      div(class: "alert mb-4 flex justify-between") do
        div do
          h4(class: "font-bold text-left") { "Version #{@gem.latest_version.version} available" }
          p(class: "text-left") do
            "Your version came out #{months_since_last_update} months before the current release"
          end
        end
        div do
          a(href: @gem.changelog, class: "btn btn-sm btn-secondary") { "Changelog" } if @gem.changelog
        end
      end
    end

    def months_since_last_update
      (@gem.latest_version.date - @gem.date).seconds.in_months.to_i
    end
  end
end
