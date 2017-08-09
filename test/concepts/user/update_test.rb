# frozen_string_literal: true
require_relative '../../test_helper'

class UserUpdateTest < ActiveSupport::TestCase
  let(:user) { users(:researcher) }

  it 'updates a users names' do
    params = { id: user.id }
    document = {
      data: {
        type: 'users',
        id: user.id.to_s,
        attributes: { name: 'SomeNewName' }
      }
    }
    options = { 'document' => document.to_json, 'current_user' => user }

    user.name.wont_equal 'SomeNewName'
    result = API::V1::User::Update.(params, options)
    result.success?.must_equal true
    user.reload.name.must_equal 'SomeNewName'
  end
end
