# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class LanguageFilterContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    subject { LanguageFilter::Contracts::Create.new(LanguageFilter.new) }

    describe 'validations' do
      describe 'always' do
        it { must_validate_length_of :identifier, is: 3 }
      end
    end
  end
end
