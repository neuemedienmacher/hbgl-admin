# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class TargetAudienceFiltersOfferCreateTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:basic_params) do
    {
      offer: Offer.first,
      target_audience_filter: TargetAudienceFilter.first,
      age_from: 0,
      age_to: 1
    }
  end

  describe '::TargetAudienceFiltersOffer::Create' do
    it 'must create a TargetAudienceFiltersOffer given valid data' do
      operation_must_work ::TargetAudienceFiltersOffer::Create, basic_params
    end

    it 'must not create a TargetAudienceFiltersOffer given invalid data' do
      params = { age_from: nil, age_to: nil }
      operation_wont_work ::TargetAudienceFiltersOffer::Create, params
    end
  end
end
