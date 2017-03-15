# frozen_string_literal: true
# NON-JSON-API getter for all states of a model. Used for statistics.
module API::V1
  class StatesController < API::V1::BackendController
    def show
      model = params[:model].camelize.constantize
      render json: API::V1::States::Show.new(model)
    end
  end
end
