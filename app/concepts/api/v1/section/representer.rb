# frozen_string_literal: true

module API::V1
  module Section
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :sections

        attributes do
          property :label, getter: ->(section) do
            section[:represented].identifier
          end

          property :identifier
          property :name
        end
      end

      class Index < Show
      end
    end
  end
end
