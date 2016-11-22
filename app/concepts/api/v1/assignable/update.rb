# frozen_string_literal: true
module API::V1
  module Assignable
    class Update < Trailblazer::Operation
      include Trailblazer::Operation::Representer

      def process(params)
        if reassign?
          update_assignment
        end
      end

      protected

      # can be overwritten by the inheriting operation (e.g. translations)
      def assignment_creator_id
        @params[:current_user].id
      end

      def assignment_reciever_id
        ::User.system_user.id
      end

      def assignment_reciever_team_id
        nil
      end

      def reassign?
        false
      end

      def message_for_new_assignment
        'Updated Assignment'
      end

      private

      def update_assignment
        @model.create_new_assignment!(
          assignment_creator_id, nil,
          assignment_reciever_id, assignment_reciever_team_id,
          message_for_new_assignment
        )
      end
    end
  end
end
