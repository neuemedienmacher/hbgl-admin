# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::DivisionsController do
  include API::ControllerTestUtils
  let(:user) { users(:researcher) }

  it '#index should respond to jsonapi requests' do
    sign_in user
    api_get_works_for :index
  end

  it 'deletes an object' do
    sign_in user
    delete :destroy, id: 1
    assert_response 200
    assert_nil Division.where(id: 1).first
  end
end
