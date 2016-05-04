# frozen_string_literal: true
module API::V1
  class LocationsController < ApplicationController
    respond_to :json

    def index
      respond API::V1::Location::Index
    end
  end
end
