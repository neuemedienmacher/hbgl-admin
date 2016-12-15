# frozen_string_literal: true
module API::V1
  module Assignable
    class Create < Trailblazer::Operation
      include Trailblazer::Operation::Representer

      def process(params)
        create_initial_assignment
      end

      protected

      # can be overwritten by inheriting operation (e.g. translations)
      def assignment_creator_id
        ::User.system_user.id
      end

      def assignment_reciever_id
        @params[:current_user].id
      end

      def assignment_reciever_team_id
        nil
      end

      def message_for_new_assignment
        'Initial Assignment'
      end

      private

      def create_initial_assignment
        # create initial Assignment from system for the creating user
        @model.create_new_assignment!(
          assignment_creator_id, nil,
          assignment_reciever_id, assignment_reciever_team_id,
          message_for_new_assignment
        )
      end
    end
  end
end
