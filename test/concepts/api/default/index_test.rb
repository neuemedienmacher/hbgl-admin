# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class DefaultIndexTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }

  describe '::Default::Index' do
    it 'must raise RuntimeError for default base_query call' do
      assert_raise(RuntimeError) { ::API::V1::Default::Index.new.base_query }
    end
  end
end
