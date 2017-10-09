# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class EmailUpdateTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:basic_params) do
    {
      id: '1',
      address: 'ChangedEmailAddress@someThing.whatever',
      security_code: 'FakedSecurityCode'
    }
  end

  describe '::Email::Update' do
    it 'must update an Email given valid data' do
      operation_must_work ::Email::Update, basic_params
    end

    describe 'validations' do
      it 'must validate security_code presence' do
        basic_params[:security_code] = nil
        operation_wont_work ::Email::Update, basic_params
      end
    end
  end
end
