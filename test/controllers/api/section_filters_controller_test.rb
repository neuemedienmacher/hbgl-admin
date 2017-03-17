# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::SectionFiltersController do
  include API::ControllerTestUtils
  let(:user) { users(:researcher) }
  before do
    sign_in user
  end

  it { api_get_works_for :index }

  it { has_no_route_for :get, :show }
  it { has_no_route_for :post, :create }
  it { has_no_route_for :patch, :update }
  it { has_no_route_for :delete, :destroy }
end
