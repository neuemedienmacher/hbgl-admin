# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
require_relative '../../support/utils/jsonapi_test_utils'

class AssignmentUpdateTest < ActiveSupport::TestCase
  include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:basic_params) do
    { id: '1', message: 'foo bla' }
  end

  describe '::Assignment::Update' do
    it 'must create an assignment given valid data' do
      operation_must_work ::Assignment::Update, basic_params
    end

    describe 'validations' do
      it 'must work for blank receiver_id' do
        basic_params[:receiver_id] = nil
        operation_must_work ::Assignment::Update, basic_params
      end

      it 'must work for correct receiver_id' do
        basic_params[:receiver_id] = user.id
        operation_must_work ::Assignment::Update, basic_params
      end

      it 'wont work for non-numerical receiver_id' do
        basic_params[:receiver_id] = 'ThisDoesNotMakeSense'
        operation_wont_work ::Assignment::Update, basic_params
      end
    end

    # TODO: A lot more tests?!
  end

  describe 'API::V1::Assignment::Update' do
    it 'must create an assignment from a JSONAPI document' do
      api_operation_must_work(
        API::V1::Assignment::Update, to_jsonapi(basic_params, 'assignments')
      )
    end
  end
end
