# frozen_string_literal: true
module API::V1
  module OfferTranslation
    class UpdateExternal < Trailblazer::Operation
      include Trailblazer::Operation::Representer, Responder

      representer Representer::Show

      include Model
      model ::OfferTranslation, :update

      contract do
        property :name
        property :description
        property :opening_specification
        property :source
        property :possibly_outdated
      end

      def process(params)
        if validate(params[:json])
          contract.save
          if model.manually_editable?
            side_effects!
          end
        end
      end

      private

      def new_assignment_required?
        # TODO: refugees only! move to monkey-patched offer_translation!
        model.manually_editable?
      end

      def side_effects!
        @model.create_new_assignment!(
          AssignmentDefaults['system_user'], nil,
          nil.id, AssignmentDefaults.translator_teams[@model.locale.to_s],
          @model.possibly_outdated ? 'Veraltet' : @model.source
        )
      end
    end
  end
end
