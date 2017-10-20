# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class AreaContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    subject { Area::Contracts::Create.new(Area.new(name: 'name')) }

    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :minlat }
    it { subject.must_respond_to :maxlat }
    it { subject.must_respond_to :minlong }
    it { subject.must_respond_to :maxlong }
    it { must_validate_presence_of :name }
    it { must_validate_presence_of :minlat }
    it { must_validate_presence_of :maxlat }
    it { must_validate_presence_of :minlong }
    it { must_validate_presence_of :maxlong }

    it 'should be valid if min < max in both cases' do
      subject.minlong = 1
      subject.maxlong = 2
      subject.minlat = 1
      subject.maxlat = 2
      subject.must_be :valid?
    end

    it 'should validate that lat min is less than max and reverse' do
      subject.minlong = 1
      subject.maxlong = 2
      subject.minlat = 2
      subject.maxlat = 1
      subject.wont_be :valid?
    end

    it 'should validate that long min is less than max and reverse' do
      subject.minlat = 1
      subject.maxlat = 2
      subject.minlong = 2
      subject.maxlong = 1
      subject.wont_be :valid?
    end
  end
end
