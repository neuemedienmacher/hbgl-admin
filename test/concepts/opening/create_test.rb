# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class OpeningCreateTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:basic_params) do
    { day: 'mon', open: '12:12', close: '12:45' }
  end

  describe '::Opening::Create' do
    it 'must create a Opening given valid data open & close' do
      result = operation_must_work ::Opening::Create, basic_params
      result['model'].name.must_equal 'Mon 12:12-12:45'
      result['model'].sort_value.must_equal 403_320_0
    end

    it 'must create a Opening given valid data open = close = nil' do
      # needed because this test is randomly failing
      Opening.delete_all
      params = { day: 'mon', open: nil, close: nil }
      result = operation_must_work ::Opening::Create, params
      result['model'].name.must_equal 'Mon (appointment)'
      result['model'].sort_value.must_equal(-360_000)
    end
  end
end
