# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class OrganizationContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    subject { Organization::Contracts::Create.new(Organization.new) }
    it { must_validate_length_of :name, maximum: 100 }
    it { must_validate_presence_of :name }
    it { must_validate_uniqueness_of :name, organizations(:basic).name }
    it { must_validate_presence_of :website }
  end

  describe 'Approve' do
    subject { Organization::Contracts::Approve.new(Organization.new) }
    it { must_validate_presence_of :description }
    it { must_validate_presence_of :legal_form }

    it 'must validate that only one hq location is given' do
      message = I18n.t('organization.validations.hq_location')

      subject.locations =
        [OpenStruct.new(hq?: true), OpenStruct.new(hq?: false)]
      subject.valid?
      subject.errors.messages[:locations].must_equal nil

      # fails when more than one are hq
      subject.locations =
        [OpenStruct.new(id: 1, hq?: true), OpenStruct.new(id: 2, hq?: true)]
      subject.valid?
      subject.errors.messages[:locations].must_include message

      # fails when none are hq
      subject.errors.delete :locations
      subject.locations = [OpenStruct.new(hq?: false)]
      subject.valid?
      subject.errors.messages[:locations].must_include message
    end
  end
end
