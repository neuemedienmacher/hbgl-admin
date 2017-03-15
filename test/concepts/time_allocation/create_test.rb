# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class TimeAllocationCreateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:super) }
  let(:basic_params) do
    {
      user_id: 1,
      week_number: 2,
      year: 2017,
      desired_wa_hours: 42,
      actual_wa_hours: 30
    }
  end

  describe '::TimeAllocation::Create' do
    it 'must create a TimeAllocation given valid data' do
      operation_must_work ::TimeAllocation::Create, basic_params
    end

    describe 'validations' do
      it 'must validate user_id' do
        basic_params[:user_id] = nil
        operation_wont_work ::TimeAllocation::Create, basic_params
        basic_params[:user_id] = 'error'
        operation_wont_work ::TimeAllocation::Create, basic_params
      end

      it 'must validate week_number' do
        basic_params[:week_number] = nil
        operation_wont_work ::TimeAllocation::Create, basic_params
        basic_params[:week_number] = 'error'
        operation_wont_work ::TimeAllocation::Create, basic_params
      end

      it 'must validate year' do
        basic_params[:year] = nil
        operation_wont_work ::TimeAllocation::Create, basic_params
        basic_params[:year] = 'error'
        operation_wont_work ::TimeAllocation::Create, basic_params
      end

      it 'must validate desired_wa_hours' do
        basic_params[:desired_wa_hours] = nil
        operation_wont_work ::TimeAllocation::Create, basic_params
        basic_params[:desired_wa_hours] = 'error'
        operation_wont_work ::TimeAllocation::Create, basic_params
      end

      it 'must validate actual_wa_hours' do
        basic_params[:actual_wa_hours] = 'error'
        operation_wont_work ::TimeAllocation::Create, basic_params
        basic_params[:actual_wa_hours] = nil
        operation_must_work ::TimeAllocation::Create, basic_params
      end

      it 'must validate uniqueness of user_id with week_number' do
        # already existing in fixtures
        basic_params[:user_id] = 1
        basic_params[:week_number] = 1
        basic_params[:year] = 2017
        operation_wont_work ::TimeAllocation::Create, basic_params
        basic_params[:week_number] = 2
        operation_must_work ::TimeAllocation::Create, basic_params
      end

      it 'must validate uniqueness of user_id with year' do
        # already existing in fixtures
        basic_params[:user_id] = 1
        basic_params[:week_number] = 1
        basic_params[:year] = 2017
        operation_wont_work ::TimeAllocation::Create, basic_params
        basic_params[:year] = 2016
        operation_must_work ::TimeAllocation::Create, basic_params
      end

      it 'must validate uniqueness of week_number with user_id' do
        # already existing in fixtures
        basic_params[:user_id] = 1
        basic_params[:week_number] = 1
        basic_params[:year] = 2017
        operation_wont_work ::TimeAllocation::Create, basic_params
        basic_params[:user_id] = 2
        operation_must_work ::TimeAllocation::Create, basic_params
      end

      it 'must validate uniqueness of week_number with year' do
        # already existing in fixtures
        basic_params[:user_id] = 1
        basic_params[:week_number] = 1
        basic_params[:year] = 2017
        operation_wont_work ::TimeAllocation::Create, basic_params
        basic_params[:year] = 2016
        operation_must_work ::TimeAllocation::Create, basic_params
      end

      it 'must validate uniqueness of year with user_id' do
        # already existing in fixtures
        basic_params[:user_id] = 1
        basic_params[:week_number] = 1
        basic_params[:year] = 2017
        operation_wont_work ::TimeAllocation::Create, basic_params
        basic_params[:user_id] = 2
        operation_must_work ::TimeAllocation::Create, basic_params
      end

      it 'must validate uniqueness of year with week_number' do
        # already existing in fixtures
        basic_params[:user_id] = 1
        basic_params[:week_number] = 1
        basic_params[:year] = 2017
        operation_wont_work ::TimeAllocation::Create, basic_params
        basic_params[:week_number] = 2
        operation_must_work ::TimeAllocation::Create, basic_params
      end
    end
  end
end
