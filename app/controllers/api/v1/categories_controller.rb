# frozen_string_literal: true

module API::V1
  class CategoriesController < BackendController
    respond_to :json

    # bulk update
    def sort
      endpoint API::V1::Category::Sort, args: [params] do |m|
        m.success do |result|
          render json: {
            status: 'success', update_count: result['update_count']
          }.to_json
        end
        m.invalid { render json: { status: 'error' }.to_json }
        m.present {}
        m.created {}
        m.not_found {}
        m.unauthenticated {}
      end
    end
  end
end
