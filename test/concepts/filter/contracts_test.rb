# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class FilterContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    subject { Filter::Contracts::Create.new(Filter.new) }

    describe 'validations' do
      describe 'always' do
        it { must_validate_presence_of :name }
        it { must_validate_uniqueness_of :name, Filter.first.name }
        it { must_validate_presence_of :identifier }
        it { must_validate_uniqueness_of :identifier, Filter.first.identifier }
      end
    end
  end
end
