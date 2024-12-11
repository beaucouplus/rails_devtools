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

      def kind
        @kind ||=
          if rack_app?
            "rack_app"
          elsif redirection?
            "redirection"
          elsif inline?
            "inline"
          else
            "controller"
          end
      end

      def verb
        return "?" if rack_app?
        @wrapped_route.verb.presence || "ALL"
      end

      def redirection?
        return false if inline?

        @route.app&.app.respond_to?(:redirect?) && @route.app.app.redirect?
      end

      def rack_app?
        return false if inline?
        return false if redirection?

        @route.app.app.respond_to?(:call) &&
          !@route.app.app.is_a?(ActionDispatch::Routing::RouteSet)
      end

      def inline?
        endpoint.include?("Proc/Lambda")
      end

      def controller?
        [inline?, redirection?, rack_app?].none?
      end

      RedirectionInfo = Data.define(:status, :block)

      def redirection_info
        return unless redirection?

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
        return endpoint if inline?
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
  end
end
