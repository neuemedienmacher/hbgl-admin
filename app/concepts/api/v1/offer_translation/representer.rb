# frozen_string_literal: true
module API::V1
  module OfferTranslation
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :offer_translations
        include API::V1::Assignable::Representer

        attributes do
          property :label, getter: ->(ot) do
            "##{ot[:represented].id} (#{ot[:represented].locale})"
          end
          property :locale
          property :source
          property :name
          property :description
          property :opening_specification
          property :possibly_outdated
          property :created_at
          property :updated_at

          property :offer_id
        end

        has_one :offer, class: ::Offer do
          type :offers

          attributes do
            property :untranslated_name
            property :approved_at
            property :created_by
            property :untranslated_description
            property :untranslated_opening_specification
          end
        end
      end

      class Index < Show
      end
    end
  end
end
