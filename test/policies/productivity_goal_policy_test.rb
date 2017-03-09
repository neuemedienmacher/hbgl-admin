# frozen_string_literal: true
require_relative '../test_helper'
require_relative '../support/utils/policy_test_utils'

class ProductivityGoalPolicyTest < ActiveSupport::TestCase
  include PolicyTestUtils

  subject { ProductivityGoalPolicy.new(user, nil) }

  describe 'for a researcher' do
    let(:user) { users(:researcher) }

    it { denies :create? }
    it { denies :update? }
  end

  describe 'for a super user' do
    let(:user) { users(:super) }

    it { allows :create? }
    it { allows :update? }
  end
end
