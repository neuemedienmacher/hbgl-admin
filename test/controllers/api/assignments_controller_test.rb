# frozen_string_literal: true
require_relative '../../test_helper'

describe API::V1::AssignmentsController do
  describe "GET 'index'" do
    it 'should respond to jsonapi requests' do
      get :index, format: 'application/vnd.api+json'
      assert_response :success
    end
  end
end
