# frozen_string_literal: true
module API::V1
  class BackendController < ApplicationController
    respond_to :json

    def index
      index_endpoint "API::V1::#{model_class_name}"
    end

    def show
      @model = model_class_name.constantize.find(params[:id])
      render "API::V1::#{model_class_name}::Representer::Show".new(@model).to_json
    end

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


    def process_params!(params)
      params.merge!(
        current_user: current_user,
        json: request.raw_post
      )
    end

    def index_endpoint base_module
      endpoint "#{base_module}::Index".constantize do |m|
        m.not_found       { |_| head 404 }
        m.unauthenticated { |_| head 401 }
        m.present         { |_| raise 'Irrelevant endpoint called' }
        m.created         { |_| raise 'Irrelevant endpoint called' }
        m.invalid         { |_| render json: 'TODO' }
        m.success do |result|
          json = API::V1::Lib::JsonifyCollection.(
            base_module, result['collection'], params
          )
          render(json: json, status: 200)
        end
      end
    end

    def model_class_name
      controller_name.classify.constantize
    end
  end
end
