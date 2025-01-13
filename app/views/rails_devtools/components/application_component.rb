# # frozen_string_literal: true

module RailsDevtools
  module Components
    class ApplicationComponent < Phlex::HTML
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::Routes
      include Phlex::Rails::Helpers::ClassNames
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::T
      include Phlex::Rails::Helpers::ContentFor
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::ImageTag
      include Phlex::Rails::Helpers::DOMID
      include Phlex::Rails::Helpers::ContentFor

      if Rails.env.development?
        def before_template
          comment { "Before #{self.class.name}" }
          super
        end
      end
    end
  end
end
