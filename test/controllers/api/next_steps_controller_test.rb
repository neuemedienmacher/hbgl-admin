# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::NextStepsController do
  include API::ControllerTestUtils
  let(:user) { users(:researcher) }
  before { sign_in users(:researcher) }

  it 'deletes' do
    sign_in users(:researcher)
    delete_works_for ::NextStep, 1
  end
  # it 'creates' do
  #   sign_in users(:researcher)
  #   create_works_with ::NextStep, text_de: 'de', text_en: 'en'
  # end
  it { api_get_works_for :index }

  it { has_no_route_for :get, :show }
  it { has_no_route_for :patch, :update }
end
