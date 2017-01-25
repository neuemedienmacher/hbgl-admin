# frozen_string_literal: true
module API::V1
  class UserTeamsController < API::V1::BackendController
    skip_before_action :authenticate_user!
    respond_to :json

    def index
      respond API::V1::UserTeam::Index
    end

    # def show
    #   @model = ::UserTeam.find(params[:id])
    #   render API::V1::UserTeam::Representer::Show.new(@model).to_json
    # end

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
