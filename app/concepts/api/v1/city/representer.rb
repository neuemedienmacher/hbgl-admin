# frozen_string_literal: true
module API::V1
  module City
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :cities
        include Default::Representer::NonStrictNaming

        attributes do
          property :name
          property :label, getter: ->(city) {
            city[:represented].name
          }
        end
      end
    end
  end
end
