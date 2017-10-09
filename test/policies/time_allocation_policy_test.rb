# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../support/utils/policy_test_utils'

class TimeAllocationPolicyTest < ActiveSupport::TestCase
  include PolicyTestUtils

  subject { TimeAllocationPolicy.new(user, record) }
  let(:record) { nil }

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

  describe 'for a user who is the TimeAllocation recipient' do
    let(:user) { User.first }
    let(:record) { TimeAllocation.new user: user }

    it { allows :report_actual? }
  end

  describe 'for a user who is not the TimeAllocation recipient' do
    let(:user) { User.first }
    let(:record) { TimeAllocation.new user: User.where.not(id: user.id).first }

    it { denies :report_actual? }
  end
end
