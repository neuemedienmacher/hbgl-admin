# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class DivisionCreateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:orga) { organizations(:basic) }
  let(:basic_params) do
    {
      name: 'DivisionName',
      description: 'DivisionDescription',
      organization: orga,
      section: orga.sections.first
    }
  end

  describe '::Division::Create' do
    it 'must create a Division given valid data' do
      operation_must_work ::Division::Create, basic_params
    end

    describe 'validations' do
      it 'must validate name' do
        basic_params[:name] = nil
        operation_wont_work ::Division::Create, basic_params
      end

      it 'must validate organization' do
        basic_params[:organization] = nil
        operation_wont_work ::Division::Create, basic_params
      end

      it 'must validate section' do
        basic_params[:section] = nil
        operation_wont_work ::Division::Create, basic_params
      end
    end
  end

  # TODO: Tests when final logic is done
end
