# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class NextStepContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    subject { NextStep::Contracts::Create.new(NextStep.new) }

    describe 'validations' do
      describe 'always' do
        it { must_validate_presence_of :text_de }
        it { must_validate_presence_of :text_en }
        it { must_validate_length_of :text_de, maximum: 255 }
        it { must_validate_length_of :text_en, maximum: 255 }
        it { must_validate_length_of :text_ar, maximum: 255 }
        it { must_validate_length_of :text_fr, maximum: 255 }
        it { must_validate_length_of :text_tr, maximum: 255 }
        it { must_validate_length_of :text_pl, maximum: 255 }
        it { must_validate_length_of :text_ru, maximum: 255 }
        it { must_validate_length_of :text_fa, maximum: 255 }
      end
    end
  end
end
