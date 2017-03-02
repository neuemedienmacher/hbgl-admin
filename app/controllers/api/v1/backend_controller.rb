# frozen_string_literal: true
module API::V1
  class BackendController < ApplicationController
    include Trailblazer::Endpoint::Controller
    respond_to :json

    # --- Default Action Handlers --- #

    def index
      # NOTE: use api_args instead of only params??
      endpoint index_operation, args: [params] do |m|
        m.success do |result|
          json = API::V1::Lib::JsonifyCollection.(
            show_representer, result['collection'], params
          )
          return render(json: json, status: 200)
        end
      end
    end

    def show
      @model = model_class_name.constantize.find(params[:id])
      render json: show_representer.new(@model).to_json
    end

    def create
      endpoint create_operation, { args: api_args }, &default_endpoints
    end

    def update
      endpoint update_operation, { args: api_args }, &default_endpoints
    end

    # --- Non-Action Helper methods --- #

    def render(*attrs)
      attrs.push({}) unless attrs[-1]
      attrs[-1][:content_type] = 'application/vnd.api+json'
      super(*attrs)
    end

    def api_args
      [params, {
        'current_user' => current_user,
        'document' => request.raw_post
      }]
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def default_endpoints
      proc do |m|
        m.created do |result|
          render json: result['representer.default.class'].new(result['model']),
                 status: 201
        end
        m.present { |_| raise 'Endpoint: presented' }
        m.not_found { |_| raise 'Endpoint: not_found' }
        m.unauthenticated { |r| render json: jsonapi_errors(r), status: 403 }
        m.success do |result|
          render json: result['representer.default.class'].new(result['model']),
                 status: 200
        end
        m.invalid { |res| render json: jsonapi_errors(res), status: 403 }
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    def model_class_name
      controller_name.classify
    end

    def base_module
      "API::V1::#{model_class_name}"
    end

    def show_representer
      "#{base_module}::Representer::Show".constantize
    end

    def index_operation
      "#{base_module}::Index".constantize
    end

    def create_operation
      "#{base_module}::Create".constantize
    end

    def update_operation
      "#{base_module}::Update".constantize
    end

    def jsonapi_errors(result)
      JsonapiErrors.generate(result)
    end
  end
end
