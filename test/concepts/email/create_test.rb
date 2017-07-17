# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class EmailCreateTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:user) { users(:super) }
  let(:basic_params) do
    {
      address: 'EmailAddress@someThing.whatever',
      aasm_state: 'uninformed'
    }
  end

  describe '::Email::Create' do
    it 'must create a Email given valid data' do
      operation_must_work ::Email::Create, basic_params
    end

    describe 'validations' do
      it 'must validate address presence' do
        basic_params[:address] = nil
        operation_wont_work ::Email::Create, basic_params
      end

      it 'must validate address format' do
        basic_params[:address] = 'invalid'
        operation_wont_work ::Email::Create, basic_params
      end

      it 'must validate address maximum length' do
        basic_params[:address] =
          'SomeVeryLongAdressThatIsTooLongForOurValidations@someExample.test'
        operation_wont_work ::Email::Create, basic_params
      end
    end
  end
end
