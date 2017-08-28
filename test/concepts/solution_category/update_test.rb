# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class SolutionCategoryUpdateTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:basic_params) do
    { id: 1, name: 'name', parent_id: nil }
  end

  describe '::SolutionCategory::Update' do
    it 'must update a SolutionCategory given valid data' do
      params = { id: 1, name: 'name', parent_id: nil }
      operation_must_work ::SolutionCategory::Update, params
    end
  end
end
