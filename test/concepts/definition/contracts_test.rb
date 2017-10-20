# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class DefinitionContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    let(:definition) { Definition.create! key: 'foo', explanation: 'bar' }
    subject { Definition::Contracts::Create.new(Definition.new) }

    describe 'validations' do
      it { must_validate_presence_of :key }
      it { must_validate_uniqueness_of :key, definition.key }
      it { must_validate_presence_of :explanation }
      it { must_validate_length_of :explanation, maximum: 500 }
      it { must_validate_length_of :key, maximum: 400 }
    end
  end
end
