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

    def update
      begin
        run API::V1::Assignment::Update
        super
        # do |op|
        #   assignable_controller = op.model.assignable_type.underscore.pluralize
        #   assignable_id = op.model.assignable_id
        #   redirection_link = "/#{assignable_controller}/#{assignable_id}/edit"
        #   redirect_to redirection_link, :flash => {
        #     :notice => 'Erfolgreich zugwiesen.'
        #   }
        # end
      rescue Trailblazer::NotAuthorizedError
        # redirect_to '/', :flash => {
        #   :alert => 'Du darfst diese Änderung nicht vornehmen!'
        # }
        puts 'Trailblazer::NotAuthorizedError'
      end
    end
  end
end
