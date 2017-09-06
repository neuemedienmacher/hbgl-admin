# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class SolutionCategoryCreateTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:basic_params) do
    { name: 'name', parent_id: nil }
  end

  describe '::SolutionCategory::Create' do
    it 'must create a SolutionCategory given valid data' do
      operation_must_work ::SolutionCategory::Create, basic_params
    end

    it 'must not create a SolutionCategory given invalid data' do
      params = { name: nil, parent_id: nil }
      operation_wont_work ::SolutionCategory::Create, params
    end
  end
end
