# frozen_string_literal: true

module API::V1
  module Area
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :areas

        attributes do
          property :name
          property :label, getter: ->(area) {
            area[:represented].name
          }
          property :created_at
          property :updated_at
        end
      end

      class Index < Show
      end
    end
  end
end
