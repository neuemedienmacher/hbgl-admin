# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::StatesController do
  include API::ControllerTestUtils
  before { sign_in users(:researcher) }

  it 'responds to a #show request' do
    get :show, params: { model: 'Offer' }
    assert_response 200
    response.body.must_include 'website_unreachable' # ie
  end

  it { has_no_route_for :get, :index }
  it { has_no_route_for :post, :create }
  it { has_no_route_for :patch, :update }
  it { has_no_route_for :delete, :destroy }
end
