# frozen_string_literal: true
module API::V1
  class BackendController < ApplicationController
    def create
      render json: @operation.to_json
    end

    def update
      render json: @operation.to_json
    end

    def render(*attrs)
      attrs[-1][:content_type] = 'application/vnd.api+json'
      super(*attrs)
    end

    protected

    def process_params!(params)
      params.merge!(
        current_user: current_user,
        json: request.raw_post
      )
    end
  end
end
