# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::TimeAllocationsController do
  include API::ControllerTestUtils
  let(:valid_params) do
    { user_id: 1, week_number: 1, year: 2000, desired_wa_hours: 2 }
  end

  describe '#create' do
    it 'unauthenticates a regular user' do
      sign_in users(:researcher)
      create_fails_with TimeAllocation, year: 2000
      response.body.must_include 'Breach'
    end

    it 'fails with incomplete data' do
      sign_in users(:super)
      create_fails_with TimeAllocation, year: 2000
      response.body.must_include 'muss ausgefüllt werden'
    end

    it 'successfully responds to a valid request' do
      sign_in users(:super)
      create_works_with TimeAllocation, valid_params
    end
  end

  describe '#update' do
    it 'unauthenticates a regular user' do
      TimeAllocation.create valid_params
      sign_in users(:researcher)
      update_fails_with TimeAllocation, 1, desired_wa_hours: 9
      response.body.must_include 'Breach'
    end

    it 'successfully responds to a valid request' do
      TimeAllocation.create valid_params
      sign_in users(:super)
      update_works_with TimeAllocation, 1, desired_wa_hours: 9
    end
  end

  it 'successfully responds to a #report_actual request' do
    TimeAllocation.create valid_params
    sign_in users(:researcher)
    set_jsonapi_raw_post({ actual_wa_hours: 1 }, TimeAllocation)
    post :report_actual, params: { year: 2000, week_number: 1 }
    assert_response 200
    response.body.must_include '"type":"time-allocations"'
    TimeAllocation.last.actual_wa_hours.must_equal 1
  end

  it { has_no_route_for :get, :index }
  it { has_no_route_for :get, :show }
  it { has_no_route_for :delete, :destroy }
end
