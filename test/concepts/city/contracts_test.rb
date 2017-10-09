# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class CityContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    subject { City::Contracts::Create.new(City.new) }

    describe 'attributes' do
      it { subject.must_respond_to :id }
      it { subject.must_respond_to :name }
    end

    describe 'validations' do
      describe 'always' do
        it { must_validate_presence_of :name }
        it { must_validate_uniqueness_of :name, City.first.name }
      end
    end
  end
end
