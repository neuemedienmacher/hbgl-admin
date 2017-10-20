# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../support/utils/policy_test_utils'

class ContactPersonTranslationPolicyTest < ActiveSupport::TestCase
  include PolicyTestUtils

  subject { ContactPersonTranslationPolicy.new(User.system_user, ContactPersonTranslation.new) }

  it { allows :update? }
end
