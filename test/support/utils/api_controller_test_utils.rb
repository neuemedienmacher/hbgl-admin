# frozen_string_literal: true
require_relative './jsonapi_test_utils'
module API
  module ControllerTestUtils
    include JsonapiTestUtils

    def jsonapi_params(additional_params = {})
      { format: 'application/vnd.api+json' }.merge(additional_params)
    end

    def api_get_works_for action, additional_params = {}
      get action, params: jsonapi_params(additional_params)
      assert_response :success
    end

    def create_works_with klass, params
      set_jsonapi_raw_post(params, klass)
      assert_difference "#{klass.name}.count", 1 do
        post :create, jsonapi_params
      end
      # Validate JSONAPI spec implementation: returns 201 + resource document
      assert_response 201
      response.body.must_include '{"data":{'
    end

    def create_fails_with klass, params
      set_jsonapi_raw_post(params, klass)
      assert_difference "#{klass.name}.count", 0 do
        post :create, jsonapi_params
      end
      # Validate JSONAPI spec implementation: returns Forbidden, error hash
      assert_response 403
      response.body.must_include '{"errors":[{"title":'
    end

    def update_works_with klass, id, params
      set_jsonapi_raw_post(params, klass)
      model = klass.find(id)
      original_attributes = collect_attributes(model, params)
      patch :update, params: jsonapi_params(id: id)
      original_attributes.wont_equal collect_attributes(model.reload, params)

      # Validate JSONAPI spec implementation: returns 200 + resource document
      assert_response :success
      response.body.must_include '{"data":{'
    end

    def update_fails_with klass, id, params
      set_jsonapi_raw_post(params, klass)
      model = klass.find(id)
      original_attributes = collect_attributes(model, params)
      patch :update, params: jsonapi_params(id: id)
      original_attributes.must_equal collect_attributes(model.reload, params)

      # Validate JSONAPI spec implementation: returns Forbidden, error hash
      assert_response 403
      response.body.must_include '{"errors":[{"title":'
    end

    def delete_works_for klass, id
      delete :destroy, params: { id: id }
      assert_response 200
      assert_nil klass.find_by(id: id)
    end

    def has_no_route_for method, action
      assert_raises(ActionController::UrlGenerationError) do # No route matches
        send(method, action) # If this raises another error, the route exists
      end
    end

    def collect_attributes(model, params)
      model.attributes.select { |key, _| params.keys.include?(key.to_sym) }
    end

    def set_jsonapi_raw_post(params, klass)
      type = klass.name.tableize
      request.env['RAW_POST_DATA'] = to_jsonapi(params, type)
    end
  end
end
