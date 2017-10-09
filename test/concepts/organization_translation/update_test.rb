# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class OrganizationTranslationUpdateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:super) }
  let(:organization) { organizations(:basic) }
  let(:basic_params) do
    {
      id: 1,
      name: 'UpdatedOrganizationTranslation',
      description: 'UpdatedOrganizationDescription',
      source: 'GoogleTranslate',
      locale: 'pl'
    }
  end

  describe '::OrganizationTranslation::Update' do
    it 'must update an OrganizationTranslation given valid data' do
      operation_must_work ::OrganizationTranslation::Update, basic_params
    end
  end
end
