# frozen_string_literal: true

module Devtools
  module Routes
    class RouteInfo
      def initialize(route, engine: "Application")
        @route = route
        @wrapped_route = ActionDispatch::Routing::RouteWrapper.new(route)
        @engine = engine
      end

      delegate :controller, :action, :constraints, :endpoint, to: :@wrapped_route

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

      def verb
        return "?" if rack_app?
        @wrapped_route.verb.presence || "ALL"
      end

      def redirection?
        @route.app&.app.respond_to?(:redirect?) && @route.app.app.redirect?
      end

      def rack_app?
        !redirection? && @route.app.app.respond_to?(:call) &&
          !@route.app.app.is_a?(ActionDispatch::Routing::RouteSet)
      end

      RedirectionInfo = Data.define(:status, :block)

      def redirection_info
        return unless redirection?
        return @redirection_info if defined?(@redirection_info)

        @redirection_info ||= RedirectionInfo.new(
          status: @route.app.app.status,
          block: @route.app.app.block
        )
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

        if matching_route.name.blank?
          return [
            @wrapped_route.defaults[:controller],
            @wrapped_route.defaults[:action]
          ].join("_")
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
