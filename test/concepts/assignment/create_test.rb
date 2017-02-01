# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
require_relative '../../support/utils/jsonapi_test_utils'

class AssignmentCreateTest < ActiveSupport::TestCase
  include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:basic_params) do
    {
      assignable_id: 1,
      assignable_type: 'OfferTranslation',
      creator_id: user.id,
      receiver_id: users(:super).id
    }
  end

  describe '::Assignment::Create' do
    it 'must create an assignment given valid data' do
      operation_must_work ::Assignment::Create, basic_params
    end

    # TODO: A lot more tests!
  end

  describe 'API::V1::Assignment::Create' do
    it 'wont create an assignment from a pure param hash' do
      api_operation_wont_work(API::V1::Assignment::Create, basic_params.to_json)
    end

    it 'must create an assignment from a JSONAPI document' do
      api_operation_must_work(
        API::V1::Assignment::Create, to_jsonapi(basic_params, 'assignments')
      )
    end
  end
end
