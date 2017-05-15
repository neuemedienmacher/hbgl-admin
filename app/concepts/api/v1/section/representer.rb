# frozen_string_literal: true
module API::V1
  module Section
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :sections
        include Default::Representer::NonStrictNaming

        attributes do
          property :label, getter: ->(section) do
            section[:represented].identifier
          end

          property :identifier
          property :name
        end
      end
    end
  end
end
