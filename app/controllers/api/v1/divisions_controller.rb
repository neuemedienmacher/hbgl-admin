# frozen_string_literal: true
module API::V1
  class DivisionsController < API::V1::BackendController
    respond_to :json

    def create
      run Division::Create
      super
    end

    def update
      run Division::Create
      super
    end
  end
end
