# frozen_string_literal: true
require_relative '../test_helper'

describe PagesController do
  describe "GET 'react'" do
    it 'should work' do
      sign_in users(:researcher)
      get :react
      assert_response :success
    end
  end
end
