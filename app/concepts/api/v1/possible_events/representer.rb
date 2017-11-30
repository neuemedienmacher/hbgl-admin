# frozen_string_literal: true

module API::V1
  module PossibleEvents
    class Show < Representable::Decorator
      include Representable::JSON

      property :id, getter: ->(r) do
        r[:represented].id
      end

      property :data, getter: ->(r) do
        events = []
        if r[:represented].respond_to?(:aasm)
          events = r[:represented].aasm.events.map do |event|
            {
              name: event.name,
              possible: r[:represented].send("may_#{event.name}?") &&
                event.name != :mark_as_done,
              failing_guards: event.instance_variable_get(:@guards)
                                   .reject do |guard|
                                     r[:represented].send(guard)
                                   end
            }
          end
        elsif r[:represented].is_a?(::Division)
          events = %i[mark_as_done mark_as_not_done].map do |event|
            {
              name: event,
              possible: r[:represented].event_possible?(event),
              failing_guards: []
            }
          end
        end
        events
      end
    end
  end
end
