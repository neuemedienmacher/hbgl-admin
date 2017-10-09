# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../support/utils/policy_test_utils'

class UserPolicyTest < ActiveSupport::TestCase
  include PolicyTestUtils

  subject { UserPolicy.new(user, record) }

  describe 'editing self' do
    let(:user) { User.first }
    let(:record) { user }

    it { allows :update? }
  end

  describe 'editing others' do
    let(:user) { User.first }
    let(:record) { User.where.not(id: user.id).first }

    it { denies :update? }
  end
end
