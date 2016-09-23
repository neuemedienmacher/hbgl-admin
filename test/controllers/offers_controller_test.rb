# frozen_string_literal: true
require_relative '../test_helper'

describe OffersController do
  describe "GET 'show'" do
    it 'should redirect to the login page when not authenticated' do
      sign_out users(:researcher)
      get :show, id: 'something'
      assert_redirected_to 'http://test.host/users/sign_in'
    end

    it 'should redirect to the remote frontend offers#show' do
      sign_in users(:researcher)
      get :show, id: 'doesntmatter'
      assert_redirected_to 'http://test.host.com/preview/angebote/doesntmatter'
    end
  end
end
