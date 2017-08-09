# frozen_string_literal: true
require_relative '../test_helper'

describe OrganizationsController do
  describe "GET 'show'" do
    it 'should redirect to the login page when not authenticated' do
      sign_out users(:researcher)
      get :show, id: 1
      assert_redirected_to 'http://test.host/users/sign_in'
    end

    it 'should redirect to frontend organization#show even w/o sections' do
      sign_in users(:researcher)
      orga = FactoryGirl.create :organization, slug: 'whatever'
      get :show, id: orga.id
      assert_redirected_to(
        'http://test.host.com/refugees/preview/organisationen/whatever'
      )
    end

    it 'should redirect to frontend organization#show with first section' do
      sign_in users(:researcher)
      orga = organizations(:basic)
      section = orga.sections.first.identifier
      get :show, id: orga.id
      assert_redirected_to(
        "http://test.host.com/#{section}/preview/organisationen/basicOrgaSlug"
      )
    end
  end
end
