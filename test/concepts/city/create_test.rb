# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class CityCreateTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:basic_params) do
    { name: 'UniqCityName' }
  end

  describe '::City::Create' do
    it 'must create a City given valid data' do
      operation_must_work ::City::Create, basic_params
    end

    describe 'validations' do
      it 'must validate name' do
        basic_params[:name] = nil
        operation_wont_work ::City::Create, basic_params
      end
    end
  end
end
