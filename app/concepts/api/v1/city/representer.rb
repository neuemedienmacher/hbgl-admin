# frozen_string_literal: true
module API::V1
  module City
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :cities

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
