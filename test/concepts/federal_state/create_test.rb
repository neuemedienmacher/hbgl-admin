# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class FederalStateCreateTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:basic_params) do
    {
      name: 'FederalStatenName'
    }
  end

  describe '::FederalState::Create' do
    it 'must create a FederalState given valid data' do
      operation_must_work ::FederalState::Create, basic_params
    end

    describe 'validations' do
      it 'must validate name presence' do
        basic_params[:name] = nil
        operation_wont_work ::FederalState::Create, basic_params
      end

      it 'must validate name uniqueness' do
        operation_must_work ::FederalState::Create, basic_params
        operation_wont_work ::FederalState::Create, basic_params
      end
    end
  end
end
