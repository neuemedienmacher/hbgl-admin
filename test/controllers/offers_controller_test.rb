# frozen_string_literal: true
require_relative '../test_helper'

describe OffersController do
  describe "GET 'show'" do
    it 'should redirect to the login page when not authenticated' do
      sign_out users(:researcher)
      get :show, id: 1
      assert_redirected_to 'http://test.host/users/sign_in'
    end

    it 'should redirect to the remote frontend offers#show' do
      sign_in users(:researcher)
      o = FactoryGirl.create :offer, slug: 'whatever'
      get :show, id: o.id
      assert_redirected_to(
        "http://test.host.com/#{o.section.identifier}/preview/angebote/whatever"
      )
    end
  end
end
