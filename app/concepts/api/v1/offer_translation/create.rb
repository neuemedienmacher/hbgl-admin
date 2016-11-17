# frozen_string_literal: true
module API::V1
  module OfferTranslation
    class Create < API::V1::Assignable::Create
      include Model
      model ::OfferTranslation, :create

      include Trailblazer::Operation::Representer
      representer API::V1::OfferTranslation::Representer::Show

      # TODO policy, contract, validations...

      contract do
        property :name
        property :description
        property :opening_specification
        property :source
        property :possibly_outdated
      end

      def process(params)
        if validate(params[:json])
          # super-call for assignable side_effects
          super(params)
          contract.save
        else
          raise "OfferTranslation form has errors: #{contract.errors.full_messages}"
        end
      end

      def assignment_reciever_id
        if assign_system?
          AssignmentDefaults['system_user']
        else
          nil
        end
      end

      def assignment_reciever_team_id
        if assign_system?
          nil
        else
          AssignmentDefaults.translator_teams[model.locale.to_s]
        end
      end

      private

      def assign_system?
        model.manually_editable?
      end
    end
  end
end
