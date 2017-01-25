# frozen_string_literal: true
module Assignable
  module CommonSideEffects
    module InitialAssignment
      # create initial Assignment from system for the creating user
      def create_initial_assignment!(*, model:, current_user:, **)
        ::Assignment::CreateInitial.(
          {}, assignable: model, last_acting_user: current_user
        ).success?
      end
    end
  end
end
