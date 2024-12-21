# frozen_string_literal: true

module RailsDevtools
  module Routes
    class RouteInfo
      attr_reader :id

      def initialize(route, id:, engine: "Application")
        @route = route
        @wrapped_route = ActionDispatch::Routing::RouteWrapper.new(route)
        @engine = engine
        @id = id
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
          if engine?
            "engine"
          elsif rack_app?
            "rack_app"
          elsif redirection?
            "redirection"
          elsif inline?
            "inline"
          else
            "controller"
          end
      end

      def engine?
        @route.app.respond_to?(:engine?) && @route.app.engine?
      end

      def verb
        return "?" if rack_app? || engine?
        @wrapped_route.verb.presence || "ALL"
      end

      def redirection?
        return false if inline?

        @route.app&.app.respond_to?(:redirect?) && @route.app.app.redirect?
      end

      def rack_app?
        return false if inline?
        return false if redirection?
        return false if engine?

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
        return "Inline route to #{path.gsub('(.:format)', '')}" if inline?
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
