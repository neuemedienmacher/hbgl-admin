# frozen_string_literal: true
module API::V1
  class OrganizationsController < API::V1::BackendController
    respond_to :json

    def show
      respond Organization::Show
    end

    def index
      respond API::V1::Organization::Index
    end

    def create
      run Organization::Create
      super
    end

    def update
      run Organization::Create
      super
    end
  end
end
