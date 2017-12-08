# frozen_string_literal: true

require_relative '../test_helper'

describe NextStepsOffersController do
  describe "GET 'index'" do
    it 'should respond to json requests for an offer' do
      sign_in FactoryBot.create :researcher
      get :index, format: :json, params: { offer_id: '1', locale: 'de' }
      assert_response :success
    end
  end

  describe "PUT 'update'" do
    it 'should respond to json requests for an offer' do
      sign_in FactoryBot.create :researcher
      put :update, format: :json, params: { id: '1', locale: 'de',
                                            next_steps_offer: { sort_value: 1 } }
      assert_response :success
    end
  end
end
