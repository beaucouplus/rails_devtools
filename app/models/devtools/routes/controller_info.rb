module Devtools
  module Routes
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
