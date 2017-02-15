# frozen_string_literal: true
require_relative '../../test_helper'

class UserUpdateTest < ActiveSupport::TestCase
  let(:user) { users(:researcher) }

  it 'updates a users current_team_id' do
    params = { id: user.id }
    document = {
      data: {
        type: 'users',
        id: user.id,
        attributes: { current_team_id: 2 }
      }
    }
    options = { 'document' => document.to_json, 'current_user' => user }

    user.current_team_id.wont_equal 2
    result = API::V1::User::Update.(params, options)
    result.success?.must_equal true
    user.reload.current_team_id.must_equal 2
  end
end
