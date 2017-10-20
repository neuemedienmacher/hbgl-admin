# frozen_string_literal: true

module API::V1
  module Email
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :emails

        attributes do
          property :address
          property :aasm_state
          property :created_at
          property :updated_at

          property :contact_person_ids
          property :offer_ids
          property :organization_ids

          property :label, getter: ->(email) do
            email[:represented].address
          end
        end
      end

      class Index < Show
      end

      class Create < Show
      end
    end
  end
end
