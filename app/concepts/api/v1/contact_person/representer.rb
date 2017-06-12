# frozen_string_literal: true
module API::V1
  module ContactPerson
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :contact_people

        attributes do
          property :area_code_1
          property :local_number_1
          property :area_code_2
          property :local_number_2
          property :fax_area_code
          property :fax_number
          property :first_name
          property :last_name
          property :operational_name
          property :academic_title
          property :gender
          property :responsibility
          property :position
          property :street
          property :zip_and_city
          property :spoc

          property :label, getter: ->(contact_person) do
            contact_person[:represented].display_name
          end

          property :email_id
          property :organization_id
        end

        has_one :organization do
          type :organizations
          attributes do
            property :name, as: :label
          end
        end

        has_one :email, decorator: API::V1::Email::Representer::Show,
                        populator: Lib::Populators::FindOrInstantiate,
                        class: ::Email
      end
    end
  end
end