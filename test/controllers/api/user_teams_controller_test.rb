# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::UserTeamsController do
  include API::ControllerTestUtils
  before { sign_in users(:super) }

  it { api_get_works_for :index }

  describe '#create' do
    it { create_works_with UserTeam, name: 'foo', rel: { users: [1, 2] } }

    it 'unauthenticates a regular user' do
      sign_in users(:researcher)
      create_fails_with UserTeam, name: 'foo', rel: { users: [1, 2] }
      response.body.must_include 'Breach'
    end

    it 'fails an incomplete request' do
      create_fails_with UserTeam, name: 'foo'
      response.body.must_include 'muss ausgefüllt werden'
      response.body.must_include '/data/attributes/users'
    end
  end

  describe '#update' do
    let(:team) { FactoryBot.create(:user_team, user_ids: [1]) }
    it { update_works_with UserTeam, team.id, name: 'foob' }

    it 'unauthenticates a regular user' do
      sign_in users(:researcher)
      update_fails_with UserTeam, team.id, name: 'foob'
      response.body.must_include 'Breach'
    end

    it 'fails with invalid params' do
      team.reload.users.must_equal [User.find(1)]
      update_fails_with UserTeam, team.id, name: '', rel: { users: [2] }
      response.body.must_include '/data/attributes/name'
      response.body.must_include 'muss ausgefüllt werden'
      team.reload.users.must_equal [User.find(1)] # still has user 1
    end
  end

  it { has_no_route_for :get, :show }
  it { has_no_route_for :delete, :destroy }
end
