# frozen_string_literal: true
module API::V1
  module Organization
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :organizations
        include API::V1::Assignable::Representer

        attributes do
          property :label, getter: ->(organization) do
            organization[:represented].name
          end
          property :description, getter: ->(organization) do
            organization[:represented].untranslated_description
          end

          property :name
          property :priority
          property :comment
          property :offers_count
          property :aasm_state
          property :locations_count
          property :pending_reason

          property :website_id
          # NOTE: do we need this here? or only for create/update or not at all?
          property :location_ids
          property :contact_person_ids
          property :division_ids
        end

        # has_one :website do
        #   type :websites
        #   attributes do
        #     property :url
        #   end
        # end
      end

      class Index < Show
      end

      class Create < Show
        attributes do
          property :description
        end

        has_one :website,
                decorator: API::V1::Website::Representer::Show,
                populator: API::V1::Lib::Populators::FindOrInstantiate,
                class: ::Website

        has_many :divisions,
                 decorator: API::V1::Division::Representer::Create,
                 populator: API::V1::Lib::Populators::FindOrInstantiate,
                 class: ::Division

        has_many :locations,
                 decorator: API::V1::Location::Representer::Create,
                 populator: API::V1::Lib::Populators::FindOrInstantiate,
                 class: ::Location

        has_many :contact_people,
                 decorator: API::V1::ContactPerson::Representer::Create,
                 populator: API::V1::Lib::Populators::FindOrInstantiate,
                 class: ::ContactPerson
      end
    end
  end
end
