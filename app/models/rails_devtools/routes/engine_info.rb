module RailsDevtools
  module Routes
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
        return "" unless engine?

        path.split("/").last.underscore
      end
    end
  end
end
