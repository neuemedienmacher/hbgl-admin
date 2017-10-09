# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class LogicVersionContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    subject { LogicVersion::Contracts::Create.new(LogicVersion.new) }

    describe 'validations' do
      describe 'always' do
        it { must_validate_presence_of :name }
        it { must_validate_uniqueness_of :name, LogicVersion.first.name }
        it { must_validate_presence_of :version }
        it { must_validate_uniqueness_of :version, LogicVersion.first.version }
      end
    end
  end
end
