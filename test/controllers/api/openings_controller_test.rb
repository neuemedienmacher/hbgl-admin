# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::OpeningsController do
  include API::ControllerTestUtils
  before { sign_in users(:researcher) }

  it { api_get_works_for :index }
end
