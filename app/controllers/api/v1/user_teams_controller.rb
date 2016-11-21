# frozen_string_literal: true
module API::V1
  class UserTeamsController < API::V1::BackendController
    skip_before_action :authenticate_user!
    respond_to :json

    def index
      respond API::V1::UserTeam::Index
    end

    def show
      respond API::V1::UserTeam::Show
    end

    def create
      run API::V1::UserTeam::Create
      super
    end

    def update
      run API::V1::UserTeam::Update
      super
    end
  end
end
