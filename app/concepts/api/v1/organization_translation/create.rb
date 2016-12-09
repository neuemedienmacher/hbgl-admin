# frozen_string_literal: true
module API::V1
  module OrganizationTranslation
    class Create < API::V1::BaseTranslation::Create
      include Model
      model ::OrganizationTranslation, :create

      include Trailblazer::Operation::Representer
      representer API::V1::OrganizationTranslation::Representer::Show

      contract do
        property :description
        property :source
        property :possibly_outdated
        property :locale
        property :organization_id
      end

      def process(params)
        if validate(params[:json], model)
          contract.save
          # super-call for assignable side_effects
          super(params)
        else
          raise "OrganizationTranslation form has errors: #{contract.errors.full_messages}"
        end
      end

      protected

      def created_by_system?
        !model.organization.section_filters.pluck(:identifier)
          .include?('refugees') || model.locale == 'de'
      end
    end
  end
end
