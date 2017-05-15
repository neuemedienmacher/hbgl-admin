# frozen_string_literal: true
module API::V1
  module Filter
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :filters
        include Default::Representer::NonStrictNaming

        attributes do
          property :label, getter: ->(filter) do
            filter[:represented].identifier
          end

          property :identifier
          property :name
        end
      end
    end
  end
end
