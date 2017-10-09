# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class OfferTranslationUpdateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:super) }
  let(:offer) { offers(:basic) }
  let(:basic_params) do
    {
      id: 1,
      name: 'UpdatedOfferTranslation',
      description: 'UpdatedOfferDescription',
      opening_specification: 'UpdatedOfferOpeningSpecification',
      source: 'GoogleTranslate',
      locale: 'pl'
    }
  end

  describe '::OfferTranslation::Update' do
    it 'must update an OfferTranslation given valid data' do
      operation_must_work ::OfferTranslation::Update, basic_params
    end
  end
end
