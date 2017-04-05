# frozen_string_literal: true
module API::V1
  module ContactPersonTranslation
    module Representer
      class Show < API::V1::Assignable::Representer::Show
        type :contact_person_translations

        property :label, getter: ->(ot) do
          "##{ot[:represented].id} (#{ot[:represented].locale})"
        end
        property :contact_person_id
        property :locale
        property :source
        property :responsibility
        property :created_at
        property :updated_at

        has_one :contact_person do
          type :contact_people

          property :id
          property :responsibility
        end
      end

      class Index < Show
      end
    end
  end
end
