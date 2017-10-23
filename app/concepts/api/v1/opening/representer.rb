# frozen_string_literal: true

module API::V1
  module Opening
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :openings

        attributes do
          property :name
          property :label, getter: ->(opening) {
            opening[:represented].name
          }
          property :day
          property :open
          property :close
          property :sort_value
          property :created_at
          property :updated_at
        end
      end

      class Index < Show
      end

      class Create < Show
      end

      class Update < Show
      end
    end
  end
end
