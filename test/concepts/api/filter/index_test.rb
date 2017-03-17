# frozen_string_literal: true
require_relative '../../../test_helper'
require_relative '../../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class FilterIndexTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }

  describe '::Filter::Index::General' do
    it 'base_query must be ::Filter per default' do
      ::API::V1::Filter::Index::General.new.base_query.must_equal ::Filter
    end
  end

  describe '::Filter::Index::SectionFilter' do
    it 'base_query must be ::SectionFilter per default' do
      ::API::V1::Filter::Index::SectionFilter.new.base_query.must_equal ::SectionFilter
    end
  end
end
