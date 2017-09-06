# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class DefinitionCreateTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:basic_params) do
    { key: 'mon', explanation: 'nom nom' }
  end

  describe '::Definition::Create' do
    it 'must create a Definition given valid data' do
      operation_must_work ::Definition::Create, basic_params
    end

    it 'must not create a Definition given invalid data' do
      params = { key: 'mon', explanation: nil }
      operation_wont_work ::Definition::Create, params
    end
  end
end
