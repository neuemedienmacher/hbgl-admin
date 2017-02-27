# frozen_string_literal: true
require_relative '../test_helper'
require_relative '../support/utils/policy_test_utils'

class OfferTranslationPolicyTest < ActiveSupport::TestCase
  include PolicyTestUtils

  subject { OfferTranslationPolicy.new(User.first, OfferTranslation.new) }

  it { allows :update? }
end
