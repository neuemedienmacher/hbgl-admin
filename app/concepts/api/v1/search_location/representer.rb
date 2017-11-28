# frozen_string_literal: true

module API::V1
  module SearchLocation
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :search_locations

        attributes do
          property :label, getter: ->(sl) do
            sl[:represented].query
          end

          property :query
          property :latitude
          property :longitude
          property :created_at
          property :updated_at
        end
      end

      class Index < Show
      end
    end
  end
end
