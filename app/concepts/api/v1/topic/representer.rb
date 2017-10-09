# frozen_string_literal: true

module API::V1
  module Topic
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :Topics

        attributes do
          property :name
          property :label, getter: ->(topic) {
            topic[:represented].name
          }
        end
      end

      class Index < Show
      end
    end
  end
end
