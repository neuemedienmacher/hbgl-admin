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
          events =
            if r[:represented].done
              [:mark_as_not_done]
            elsif !r[:represented].done && r[:represented].organization.approved?
              [:mark_as_done]
            else
              []
            end
        end
        events
      end
    end
  end
end
