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
  end
end
