# frozen_string_literal: true
module API::V1
  module OrganizationTranslation
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :organization_translations

        property :label, getter: ->(ot) do
          "##{ot[:represented].id} (#{ot[:represented].locale})"
        end
        property :organization_id
        property :locale
        property :source
        property :description
        property :possibly_outdated
        property :created_at
        property :updated_at

        has_one :organization do
          type :organizations

          property :id
          property :description
        end

        # property :organization_section, getter: ->(ot) do
        #   ot[:represented].organization.section_filters.pluck(:identifier)
        # end
      end

      class Index < Show
      end
    end
  end
end
