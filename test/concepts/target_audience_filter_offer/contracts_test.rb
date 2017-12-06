# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class TargetAudienceFiltersOfferContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    subject do
      TargetAudienceFiltersOffer::Contracts::Create.new(
        TargetAudienceFiltersOffer.new
      )
    end

    describe 'validations' do
      describe 'always' do
        it { must_validate_presence_of :target_audience_filter }
        it { must_validate_presence_of :age_from }
        it { must_validate_presence_of :age_to }

        it 'should ensure that age_from fits age_to' do
          subject.age_from = 9
          subject.age_to = 10
          subject.valid?
          assert_empty subject.errors.messages[:age_from]

          subject.age_to = 1
          subject.valid?
          subject.errors.messages[:age_from]
                 .must_include 'darf nicht größer sein als Age to'
        end

        it 'should validate age_from' do
          subject.age_from = 10
          subject.valid?
          assert_empty subject.errors.messages[:age_from]

          subject.age_from = -1
          subject.valid?
          subject.errors.messages[:age_from]
                 .must_include 'muss zwischen 0 und 99 liegen'

          subject.age_from = 100
          subject.errors.delete :age_from
          subject.valid?
          subject.errors.messages[:age_from]
                 .must_include 'muss zwischen 0 und 99 liegen'

          subject.age_from = nil
          subject.valid?
          subject.errors.messages[:age_from]
                 .must_include 'muss ausgefüllt werden'
        end

        it 'should validate age_from for parents' do
          subject.age_from = 10
          subject.age_visible = true
          subject.target_audience_filter =
            TargetAudienceFilter.where(identifier: 'family_parents').first
          subject.valid?
          subject.errors.messages[:age_from]
                 .must_include 'muss über 11 sein'

          subject.age_visible = false
          subject.errors.delete :age_from
          subject.valid?
          assert_empty subject.errors.messages[:age_from]

          subject.age_visible = true
          subject.errors.delete :age_from
          subject.age_from = 12
          subject.valid?
          assert_empty subject.errors.messages[:age_from]
        end

        it 'should validate age_to' do
          subject.age_to = 10
          subject.valid?
          assert_empty subject.errors.messages[:age_to]

          subject.age_to = -1
          subject.errors.delete :age_to
          subject.valid?
          subject.errors.messages[:age_to]
                 .must_include 'muss zwischen 0 und 99 liegen'

          subject.age_to = 100
          subject.errors.delete :age_to
          subject.valid?
          subject.errors.messages[:age_to]
                 .must_include 'muss zwischen 0 und 99 liegen'

          subject.age_to = nil
          subject.errors.delete :age_to
          subject.valid?
          subject.errors.messages[:age_to].must_include 'muss ausgefüllt werden'
        end
      end
    end
  end
end
