# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class OfferTranslationCreateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:offer) { offers(:basic) }
  let(:basic_params) do
    {
      offer_id: offer.id,
      name: 'OfferTranslation',
      description: 'OfferDescription',
      opening_specification: 'OfferOpeningSpecification',
      source: 'GoogleTranslate',
      locale: 'pl'
    }
  end

  describe '::OfferTranslation::Create' do
    it 'must create an OfferTranslation given valid data' do
      operation_must_work ::OfferTranslation::Create, basic_params
    end
  end
end
