# frozen_string_literal: true
module Assignable
  module CommonSideEffects
    module InitialAssignment
      # create initial Assignment from system for the creating user
      def create_initial_assignment!(options, model:, **)
        ::Assignment::CreateInitial.(
          {}, assignable: model, last_acting_user: creating_user_struct(model)
        ).success?
      end

      private

      def creating_user_struct(model)
        user = ::User.find(model.translated_model.created_by)
        OpenStruct.new(id: user.id, role: user.role)
      end
    end
  end
end
