# frozen_string_literal: true
require_relative '../../../test_helper'
require_relative '../../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class ProductivityGoalIndexTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }

  describe '::ProductivityGoal::Index' do
    it 'base_query must be ::ProductivityGoal per default' do
      ::API::V1::ProductivityGoal::Index.new.base_query.must_equal ::ProductivityGoal
    end
  end
end
