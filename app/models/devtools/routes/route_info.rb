# frozen_string_literal: true

module Devtools
  module Routes
    class RouteInfo
      def initialize(wrapped_route, engine: "Application")
        @wrapped_route = wrapped_route
        @engine = engine
      end

      delegate :controller, :action, :verb, :constraints, to: :@wrapped_route

      def segments
        @wrapped_route.parts.reject { |p| p == :format }
      end

      def controller_info
        @controller_info ||= ControllerInfo.new(
          controller_name: controller,
          action: action
        )
      end

      def name
        @name ||= route_name
      end

      def path
        return @wrapped_route.path if @engine == "Application"
        engine_info.path + @wrapped_route.path
      end

      def engine_info
        @engine_info ||= EngineInfo.new(@engine)
      end

      private

      def route_name
        return @wrapped_route.name if @wrapped_route.name.present?

        matching_route = engine_info.engine.routes.routes.find do |r|
          r.path.spec.to_s == @wrapped_route.path
        end

        matching_route.name
      end
    end

    class EngineInfo
      def initialize(engine_name)
        @engine_name = engine_name
      end

      def engine
        return Rails.application if @engine_name == "Application"
        @engine_name.constantize
      end

      def engine?
        @engine_name != "Application"
      end

      def name
        @engine_name
      end

      def path
        @path ||= engine.routes.find_script_name({})
      end

      def helper_prefix
        path.gsub("/", "").underscore
      end
    end

    class ControllerInfo
      attr_reader :action

      def initialize(controller_name: nil, action: nil)
        @controller_name = controller_name
        @action = action
      end

      def file_path
        full_class_name.underscore + ".rb"
      end

      def full_class_name
        @full_class_name ||= [@controller_name, "controller"].join("_").camelize
      end

      def controller
        @controller ||= full_class_name.safe_constantize
      end

      def action_exists?
        return false unless controller
        controller.action_methods.include?(@action)
      end
    end
  end
end
