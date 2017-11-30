# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::LogicVersionsController do
  include API::ControllerTestUtils
  before { sign_in users(:researcher) }
  let(:user) { users(:researcher) }

  it '#index should respond to jsonapi requests' do
    sign_in user
    api_get_works_for :index
  end
  it { api_get_works_for :index }
end
