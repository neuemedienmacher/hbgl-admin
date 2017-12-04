# frozen_string_literal: true

module API::V1
  module Contact
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :contacts

        attributes do
          property :label, getter: ->(contact) do
            contact[:represented].name
          end

          property :email
          property :name
          property :url
          property :message
          property :city
          property :internal_mail
        end
      end

      class Index < Show
      end
    end
  end
end
