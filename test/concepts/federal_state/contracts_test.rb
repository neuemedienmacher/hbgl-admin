# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class FederalStateContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    subject { FederalState::Contracts::Create.new(FederalState.new) }

    describe 'validations' do
      describe 'always' do
        it { must_validate_presence_of :name }
        it { must_validate_uniqueness_of :name, FederalState.first.name }
      end
    end
  end
end
