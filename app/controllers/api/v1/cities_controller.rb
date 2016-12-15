# frozen_string_literal: true
module API::V1
  class CitiesController < ApplicationController
    respond_to :json

    def index
      respond API::V1::City::Index
    end
  end
end
