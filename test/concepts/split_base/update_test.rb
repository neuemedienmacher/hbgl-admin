# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class SplitBaseUpdateTest < ActiveSupport::TestCase
  include OperationTestUtils

  describe '::SplitBase::Update' do
    it 'must update a SplitBase given valid data' do
      params = { id: 1, clarat_addition: 'nil' }
      operation_must_work ::SplitBase::Update, params
    end
  end
end
