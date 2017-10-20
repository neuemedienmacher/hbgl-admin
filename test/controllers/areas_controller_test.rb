# frozen_string_literal: true

require_relative '../test_helper'

describe API::V1::AreasController do
  describe "GET 'index'" do
    it 'should respond to json requests for an offer' do
      sign_in FactoryGirl.create :researcher
      get :index, format: :json
      assert_response :success
    end
  end
end
