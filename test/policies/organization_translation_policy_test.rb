# frozen_string_literal: true
require_relative '../test_helper'
require_relative '../support/utils/policy_test_utils'

class OrganizationTranslationPolicyTest < ActiveSupport::TestCase
  include PolicyTestUtils

  subject { OrganizationTranslationPolicy.new(nil, nil) }

  it { allows :update? }
end
