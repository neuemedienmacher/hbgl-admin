module API::V1
  class CategoriesController < ApplicationController
    respond_to :json

    def index
      respond API::V1::Category::Index
    end
  end
end
