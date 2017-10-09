# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class SplitBaseCreateTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:basic_params) do
    { clarat_addition: 'addition',
      title: 'title',
      solution_category: SolutionCategory.first }
  end

  describe '::SplitBase::Create' do
    it 'must create a SplitBase given valid data' do
      operation_must_work ::SplitBase::Create, basic_params
    end

    it 'must not create a SplitBase given invalid data' do
      params = { clarat_addition: nil,
                 title: 'title' }
      operation_wont_work ::SplitBase::Create, params
    end
  end
end
