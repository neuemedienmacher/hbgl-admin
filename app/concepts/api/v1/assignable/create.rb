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
        AssignmentDefaults['system_user']
      end

      def assignment_reciever_id
        @params[:current_user].id
      end

      def assignment_reciever_team_id
        nil
      end

      private

      def create_initial_assignment
        # create initial Assignment from system for the creating user
        recieving_user = ::User.find(assignment_reciever_id)
        @model.create_new_assignment!(
          assignment_creator_id, nil,
          recieving_user.id, assignment_reciever_team_id,
          message = 'Initial Assignment for ' + recieving_user.name
        )
      end
    end
  end
end
