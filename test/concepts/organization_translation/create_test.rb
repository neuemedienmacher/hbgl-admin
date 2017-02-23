# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class OrganizationTranslationCreateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:orga) { organizations(:basic) }
  let(:basic_params) do
    {
      organization_id: orga.id,
      description: 'OrganizationDescription',
      source: 'GoogleTranslate',
      locale: 'pl'
    }
  end

  describe '::OrganizationTranslation::Create' do
    it 'must create an OrganizationTranslation given valid data' do
      operation_must_work ::OrganizationTranslation::Create, basic_params
    end
  end
end
