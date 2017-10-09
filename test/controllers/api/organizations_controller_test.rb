# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::OrganizationsController do
  include API::ControllerTestUtils
  let(:user) { users(:researcher) }
  before do
    sign_in user
  end

  it '#index should respond to jsonapi requests' do
    api_get_works_for :index
  end

  it '#show should respond to jsonapi requests' do
    api_get_works_for :show, id: 1
  end

  # describe '#create' do
  #   it 'should successfully handle an update request' do
  #     update_works_with Organization, 1, description: 'changed'
  #   end
  # end

  # describe '#update' do
  #   it 'should successfully handle an update request' do
  #     update_works_with Organization, 1, description: 'changed'
  #   end
  # end
end
