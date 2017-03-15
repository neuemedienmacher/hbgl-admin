# frozen_string_literal: true
require_relative '../../../test_helper'
require_relative '../../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class CategorySortTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:basic_params) do
    {
      categories: {
        '1' => { id: 2, children: { '2' => { id: 3, children: {} } } }
      }
    }
  end

  describe '::Category::Sort' do
    it 'must sort a Category given valid data' do
      result = run_operation ::API::V1::Category::Sort, basic_params
      result.must_be :success?
    end

    it 'must change the sort_order of the category' do
      assert_nil Category.find(2).sort_order
      result = run_operation ::API::V1::Category::Sort, basic_params
      result.must_be :success?
      Category.find(2).sort_order.must_equal 2 # given sort_order + 1
    end

    it 'must change the parent_id of the children-category' do
      Category.find(3).parent_id.must_equal 1
      result = run_operation ::API::V1::Category::Sort, basic_params
      result.must_be :success?
      Category.find(3).parent_id.must_equal 2
    end
  end
end
