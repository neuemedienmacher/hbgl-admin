# frozen_string_literal: true
module API::V1
  class OrganizationsController < ApplicationController
    respond_to :json

    def show
      respond Organization::Show
    end

    def index
      respond API::V1::Organization::Index
    end
  end
end
