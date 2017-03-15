# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class TimeAllocationUpdateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:super) }
  let(:basic_params) do
    {
      id: 1,
      actual_wa_hours: 30
    }
  end

  describe '::TimeAllocation::Update' do
    it 'must update a TimeAllocation given valid data' do
      operation_must_work ::TimeAllocation::Update, basic_params
    end

    describe 'validations' do
      it 'must validate numericality of user_id' do
        basic_params[:user_id] = 'error'
        operation_wont_work ::TimeAllocation::Update, basic_params
      end

      it 'must validate numericality of week_number' do
        basic_params[:week_number] = 'error'
        operation_wont_work ::TimeAllocation::Update, basic_params
      end

      it 'must validate numericality of year' do
        basic_params[:year] = 'error'
        operation_wont_work ::TimeAllocation::Update, basic_params
      end

      it 'must validate numericality of desired_wa_hours' do
        basic_params[:desired_wa_hours] = 'error'
        operation_wont_work ::TimeAllocation::Update, basic_params
      end

      it 'must validate numericality of actual_wa_hours' do
        basic_params[:actual_wa_hours] = 'error'
        operation_wont_work ::TimeAllocation::Update, basic_params
      end
    end
  end
end
