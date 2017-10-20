# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class LocationCreateTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:orga) { organizations(:basic) }
  let(:city) { cities(:basic) }
  let(:federal_state) { federal_states(:basic) }
  let(:basic_params) do
    {
      name: 'LocationName',
      street: 'LocationStreet 23',
      in_germany: false,
      zip: '12345',
      organization: orga,
      city: city,
      federal_state: federal_state
    }
  end

  describe '::Location::Create' do
    it 'must create a Location given valid data' do
      operation_must_work ::Location::Create, basic_params
    end

    describe 'validations' do
      it 'must validate street' do
        basic_params[:street] = nil
        operation_wont_work ::Location::Create, basic_params
      end

      it 'must validate zip when in_germany is true' do
        basic_params[:zip] = nil
        basic_params[:in_germany] = true
        operation_wont_work ::Location::Create, basic_params
      end

      it 'must validate organization' do
        basic_params[:organization] = nil
        operation_wont_work ::Location::Create, basic_params
      end

      it 'must validate city' do
        basic_params[:city] = nil
        operation_wont_work ::Location::Create, basic_params
      end

      it 'must validate federal_state' do
        basic_params[:federal_state] = nil
        operation_wont_work ::Location::Create, basic_params
      end
    end
  end
end
