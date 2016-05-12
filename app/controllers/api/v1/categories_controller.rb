# frozen_string_literal: true
module API::V1
  class CategoriesController < ApplicationController
    respond_to :json

    def index
      respond API::V1::Category::Index
    end

    # bulk update
    def sort
      run API::V1::Category::Sort do |operation|
        return render json: '{"status":"success", "update_count":'\
                            "#{operation.update_count}}"
      end

      render json: '{"status": "error"}'
    end
  end
end
