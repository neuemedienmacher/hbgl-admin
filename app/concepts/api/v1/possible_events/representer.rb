# frozen_string_literal: true
module API::V1
  module PossibleEvents
    class Show < Representable::Decorator
      include Representable::JSON

      property :data, getter: ->(r) do
        events = []
        if r[:represented].respond_to?(:aasm)
          events = r[:represented].aasm.events.select do |event|
            r[:represented].send("may_#{event.name}?") &&
              event.name != :mark_as_done
          end.map(&:name)
        elsif r[:represented].is_a?(::Division)
          events = r[:represented].done ? [:mark_as_not_done] : [:mark_as_done]
        end
        events
      end
    end
  end
end
