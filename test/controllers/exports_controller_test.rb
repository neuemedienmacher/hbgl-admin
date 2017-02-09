# frozen_string_literal: true
require_relative '../test_helper'

describe ExportsController do
  describe "POST 'create'" do
    it 'should start a streaming export' do
      sign_in users(:researcher)
      post :create, object_name: 'cities'
      binding.pry
      assert_response :success
    end
  end
end
