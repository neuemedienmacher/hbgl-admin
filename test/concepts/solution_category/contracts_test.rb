# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class SolutionCategoryContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    subject { SolutionCategory::Contracts::Create.new(SolutionCategory.new) }

    describe 'validations' do
      describe 'always' do
        it { must_validate_presence_of :name }
      end
    end
  end
end
