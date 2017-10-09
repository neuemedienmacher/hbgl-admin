# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class TagContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    subject { Tag::Contracts::Create.new(Tag.new) }

    describe 'validations' do
      describe 'always' do
        it { must_validate_presence_of :name_de }
        it { must_validate_presence_of :name_en }
        it { must_validate_length_of :explanations_de, maximum: 500 }
        it { must_validate_length_of :explanations_en, maximum: 500 }
        it { must_validate_length_of :explanations_ar, maximum: 500 }
        it { must_validate_length_of :explanations_fa, maximum: 500 }
      end
    end
  end
end
