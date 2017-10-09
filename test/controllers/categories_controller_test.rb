# frozen_string_literal: true

require_relative '../test_helper'

describe CategoriesController do
  # TODO: Do we still need this action?
  # describe "GET 'index'" do
  #   it 'should respond to json requests for an offer' do
  #     sign_in FactoryGirl.create :researcher
  #     get :index, format: :json, offer_name: 'bla',
  #                 locale: 'de', section: 'family'
  #     assert_response :success
  #   end
  # end

  describe 'GET #suggest_categories' do
    it 'should render a list of category names in offers with given name' do
      sign_in users(:researcher)
      get :suggest_categories, params: { offer_name: 'basicOfferName', format: :json }
      assert_response 200
      response.body.must_include '["main1"]'
    end
  end
end
