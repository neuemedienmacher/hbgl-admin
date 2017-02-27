# frozen_string_literal: true
require_relative '../test_helper'
require_relative '../support/utils/policy_test_utils'

class ExportPolicyTest < ActiveSupport::TestCase
  include PolicyTestUtils

  subject { ExportPolicy.new(User.first, nil) }

  it { allows :create? }
end
