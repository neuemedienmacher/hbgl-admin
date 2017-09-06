# frozen_string_literal: true
module API::V1
  module Definition
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :Definitions

        attributes do
          property :key
          property :explanation
          # property :label, getter: ->(definition) {
          #   definition[:represented].key
          # }
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
