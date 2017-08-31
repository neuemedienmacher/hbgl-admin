# frozen_string_literal: true
module API::V1
  module Subscription
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :subscriptions

        attributes do
          property :email
          property :label, getter: ->(subscription) {
            subscription[:represented].email
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
