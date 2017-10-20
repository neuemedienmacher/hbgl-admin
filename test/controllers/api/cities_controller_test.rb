# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::CitiesController do
  include API::ControllerTestUtils
  before { sign_in users(:researcher) }

  it { api_get_works_for :index }

  it { has_no_route_for :get, :show }
  it { has_no_route_for :post, :create }
  it { has_no_route_for :patch, :update }
  it { has_no_route_for :delete, :destroy }
end
