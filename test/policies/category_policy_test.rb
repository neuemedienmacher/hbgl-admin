# frozen_string_literal: true
require_relative '../test_helper'
require_relative '../support/utils/policy_test_utils'

class CategoryPolicyTest < ActiveSupport::TestCase
  include PolicyTestUtils

  subject { CategoryPolicy.new(User.new, Category.new) }

  it { denies_everything }
end
