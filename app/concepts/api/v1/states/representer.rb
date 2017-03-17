# frozen_string_literal: true
require 'roar/decorator'
require 'roar/json/json_api'
module API::V1
  module States
    class Show < Roar::Decorator
      include Roar::JSON::JSONAPI

      property :states, getter: ->(r) do
        r[:represented].aasm.states_for_select.map(&:last)
      end
    end
  end
end
