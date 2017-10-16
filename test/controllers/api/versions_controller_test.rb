# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::VersionsController do
  include API::ControllerTestUtils
  before { sign_in users(:researcher) }
  let(:user) { users(:researcher) }

  it 'works for index' do
    api_get_works_for :index, item_id: 1, item_type: 'Offer'
  end

  it { has_no_route_for :get, :show }
  it { has_no_route_for :post, :create }
  it { has_no_route_for :patch, :update }
  it { has_no_route_for :delete, :destroy }
end
