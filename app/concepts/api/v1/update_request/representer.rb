# frozen_string_literal: true
module API::V1
  module UpdateRequest
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :update_requests

        attributes do
          property :email
          property :search_location
          property :label, getter: ->(update_request) {
            update_request[:represented].email
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
