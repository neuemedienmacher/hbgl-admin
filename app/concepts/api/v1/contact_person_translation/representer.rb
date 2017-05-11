# frozen_string_literal: true
module API::V1
  module ContactPersonTranslation
    module Representer
      class Show < API::V1::Assignable::Representer::Show
        include Roar::JSON::JSONAPI.resource :contact_person_translations

        attributes do
          property :label, getter: ->(ot) do
            "##{ot[:represented].id} (#{ot[:represented].locale})"
          end
          property :locale
          property :source
          property :responsibility
          property :created_at
          property :updated_at

          property :contact_person_id
        end

        has_one :contact_person do
          type :contact_people

          attributes do
            property :responsibility
          end
        end
      end

      class Index < Show
      end
    end
  end
end
