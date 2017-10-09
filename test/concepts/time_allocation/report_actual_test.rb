# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class ReportActualCreateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:other_user) { users(:super) }
  let(:basic_params) do
    {
      week_number: 1,
      year: 2017,
      desired_wa_hours: 42,
      actual_wa_hours: 30
    }
  end

  describe '::TimeAllocation::ReportActual' do
    it 'must update a TimeAllocation given valid data' do
      operation_must_work ::TimeAllocation::ReportActual, basic_params, current_user: user
    end

    describe '#dynamic_find_model' do
      it 'must find existing TimeAllocation' do
        result = run_operation ::TimeAllocation::ReportActual, basic_params, current_user: user
        result['model'].class.to_s.must_equal 'TimeAllocation'
      end

      it 'must create a new TimeAllocation' do
        basic_params[:week_number] = 42
        result = run_operation ::TimeAllocation::ReportActual, basic_params, current_user: user
        result['model'].class.to_s.must_equal 'TimeAllocation'
        result['model'].id.must_equal 2
        result['model'].week_number.must_equal 42
      end
    end
  end
end
