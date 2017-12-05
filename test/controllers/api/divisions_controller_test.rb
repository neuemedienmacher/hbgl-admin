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

  it 'does not delete a division if there are  dependent offers' do
    sign_in user
    delete_fails_for ::Division, 1
  end

  it 'deletes a division if there are no dependent objects' do
    sign_in user
    d = Division.find 1
    d.offers.delete_all
    delete_works_for ::Division, 1
  end
end
