# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../support/utils/policy_test_utils'

class AssignmentPolicyTest < ActiveSupport::TestCase
  include PolicyTestUtils

  subject { AssignmentPolicy.new(User.first, Assignment.new) }

  it { allows :create? }
  it { allows :update? }
end
