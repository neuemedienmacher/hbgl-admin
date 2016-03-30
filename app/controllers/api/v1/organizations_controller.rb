module API::V1
  class OrganizationsController < ApplicationController
    respond_to :json

    def index
      respond API::V1::Organization::Index
    end
  end
end
