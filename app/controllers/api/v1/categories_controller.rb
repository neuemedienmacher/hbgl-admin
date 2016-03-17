module API::V1
  class CategoriesController < ApplicationController
    respond_to :json

    def index
      respond Category::Index
    end
  end
end
