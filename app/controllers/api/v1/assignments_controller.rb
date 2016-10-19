# frozen_string_literal: true
module API::V1
  class AssignmentsController < API::V1::BackendController
    skip_before_action :authenticate_user!
    respond_to :json

    def index
      respond API::V1::Assignment::Index
    end

    def show
      respond API::V1::Assignment::Show
    end

    def create
      run API::V1::Assignment::Create
      super
    end

    def assign_and_edit_assignable
      puts 'AssignmentsController: assign_and_edit_assignable'
      run API::V1::Assignment::AssignAndEditAssignable do |op|
        assignable_controller = op.model.assignable_type.underscore.pluralize
        redirect_to "/#{assignable_controller}/#{op.model.assignable_id}/edit"
      end
      # TODO: what happens if operation fails?
    end
  end
end
