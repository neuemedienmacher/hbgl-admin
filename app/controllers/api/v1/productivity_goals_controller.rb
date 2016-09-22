# frozen_string_literal: true
module API::V1
  class ProductivityGoalsController < API::V1::BackendController
    skip_before_action :authenticate_user!
    respond_to :json

    def index
      respond API::V1::ProductivityGoal::Index
    end

    def create
      run ProductivityGoal::Create
      super
    end
  end
end
