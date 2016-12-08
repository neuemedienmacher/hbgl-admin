# frozen_string_literal: true
# NON-JSON-API getter for all states of a model. Used for statistics.
module API::V1
  class StatesController < API::V1::BackendController
    respond_to :json

    def show
      model = params[:model].camelize.constantize
      respond_with API::V1::States::Show.new(model)
    end
  end
end
