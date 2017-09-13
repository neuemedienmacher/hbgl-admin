# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class TopicContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    subject { Topic::Contracts::Create.new(Topic.new(name: 'name')) }

    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
  end
end
