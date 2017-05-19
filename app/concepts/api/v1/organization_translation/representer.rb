# frozen_string_literal: true
module API::V1
  module OrganizationTranslation
    module Representer
      class Show < API::V1::Assignable::Representer::Show
        include Roar::JSON::JSONAPI.resource :organization_translations

        attributes do
          property :label, getter: ->(ot) do
            "##{ot[:represented].id} (#{ot[:represented].locale})"
          end
          property :locale
          property :source
          property :description
          property :possibly_outdated
          property :created_at
          property :updated_at

          property :organization_id
        end

        has_one :organization, class: ::Organization do
          type :organizations

          attributes do
            property :description
          end
        end

        # property :organization_section, getter: ->(ot) do
        #   ot[:represented].organization.sections.pluck(:identifier)
        # end
      end
    end
  end
end
