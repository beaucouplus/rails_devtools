module RailsDevtools
  module Components
    class FlashMessage < Components::ApplicationComponent
      def initialize(message:)
        @message = message
      end

      def view_template
        div(
          class: "transition transform duration-1000 hidden",
          data: {
            controller: "notification",
            notification_delay_value: "2000",
            transition_enter_from: "opacity-0 translate-x-6",
            transition_enter_to: "opacity-100 translate-x-0",
            transition_leave_from: "opacity-100 translate-x-0",
            transition_leave_to: "opacity-0 translate-x-6"
          }
        ) do
          div(class: "toast toast-top toast-end") do
            div(role: "alert", class: "alert alert-success") do
              span { @message }
            end
          end
        end
      end
    end
  end
end
