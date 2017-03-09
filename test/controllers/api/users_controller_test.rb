# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::UsersController do
  include API::ControllerTestUtils
  before { sign_in users(:researcher) }

  it { api_get_works_for :index }

  describe '#update' do
    it { update_works_with User, 1, current_team_id: 2 }

    it 'unauthenticates a user other than the edited user' do
      update_fails_with User, 2, current_team_id: 1
      response.body.must_include 'Breach'
    end
  end

  it { has_no_route_for :get, :show }
  it { has_no_route_for :post, :create }
  it { has_no_route_for :delete, :destroy }
end
