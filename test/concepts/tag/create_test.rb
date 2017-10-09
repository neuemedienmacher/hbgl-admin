# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class TagCreateTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:basic_params) do
    { name_de: 'mon', name_en: 'nom nom' }
  end

  describe '::Tag::Create' do
    it 'must create a Tag given valid data' do
      operation_must_work ::Tag::Create, basic_params
    end

    it 'must not create a Tag given invalid data' do
      # needed because this test is randomly failing
      params = { name_de: 'mon', name_en: nil }
      operation_wont_work ::Tag::Create, params
    end
  end
end
