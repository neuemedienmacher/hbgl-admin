# frozen_string_literal: true

# NON-JSON-API getter for all column names of and associated with a model.
# Used for Exports.
module API::V1
  class FieldSetController < API::V1::BackendController
    respond_to :json

    def show
      model = params[:model].underscore.camelize.constantize
      render json: API::V1::FieldSet::Show.new(model)
    end
  end
end
