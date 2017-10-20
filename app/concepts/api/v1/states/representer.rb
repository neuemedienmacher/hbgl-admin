# frozen_string_literal: true

module API::V1
  module States
    class Show < Representable::Decorator
      include Representable::JSON

      property :states, getter: ->(r) do
        r[:represented].aasm.states_for_select.map(&:last)
      end
    end

    class Index < Show
    end
  end
end
