# frozen_string_literal: true
module API::V1
  module OfferTranslation
    class Create < API::V1::BaseTranslation::Create
      include Model
      model ::OfferTranslation, :create

      include Trailblazer::Operation::Representer
      representer API::V1::OfferTranslation::Representer::Show

      contract do
        property :name
        property :description
        property :opening_specification
        property :source
        property :locale
        property :possibly_outdated
        property :offer_id
      end

      def process(params)
        if validate(params[:json], model)
          contract.save
          # super-call for assignable side_effects
          super(params)
        else
          raise "OfferTranslation form has errors: #{contract.errors.full_messages}"
        end
      end

      protected

      def created_by_system?
        model.locale == 'de' ||
          !model.offer.section_filters.pluck(:identifier).include?('refugees')
      end
    end
  end
end
