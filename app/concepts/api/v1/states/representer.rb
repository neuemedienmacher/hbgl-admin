# frozen_string_literal: true
module API::V1
  module States
    class Show < Roar::Decorator
      include Roar::JSON

      property :states, getter: ->(r) do
        r[:represented].aasm.states_for_select.map(&:last)
      end
    end
  end
end
