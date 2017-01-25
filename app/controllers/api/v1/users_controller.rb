# frozen_string_literal: true
module API::V1
  class UsersController < API::V1::BackendController
    skip_before_action :authenticate_user!
    respond_to :json

    def index
      respond API::V1::User::Index
    end

    # def show
    #   @model = ::User.find(params[:id])
    #   render API::V1::User::Representer::Show.new(@model).to_json
    # end

    def update
      run User::Update, params: params.merge(
        current_user: current_user, user: request.raw_post
      )
      super
    end
  end
end
