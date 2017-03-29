# frozen_string_literal: true
require_relative '../test_helper'
require_relative '../support/utils/policy_test_utils'

class OfferPolicyTest < ActiveSupport::TestCase
  include PolicyTestUtils

  subject { OfferPolicy.new(User.first, Offer.new) }

  it { denies_everything }
end
