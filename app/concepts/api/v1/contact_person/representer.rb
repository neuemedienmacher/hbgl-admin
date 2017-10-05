# frozen_string_literal: true
module API::V1
  module ContactPerson
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :contact_people

        attributes do
          property :responsibility
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
          property :position
          # property :street
          # property :zip_and_city
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
            property :label, getter: ->(o) { o[:represented].name }
            property :name
          end
        end

        has_one :email do
          type :emails
          attributes do
            property :label, getter: ->(o) { o[:represented].address }
            property :address
          end
        end
      end

      class Index < Show
      end

      class Create < Show
        has_one :email, decorator: API::V1::Email::Representer::Show,
                        populator: API::V1::Lib::Populators::FindOrInstantiate,
                        class: ::Email

        has_one :organization,
                decorator: API::V1::Organization::Representer::Show,
                populator: API::V1::Lib::Populators::Find,
                class: ::Organization
      end
    end
  end
end
