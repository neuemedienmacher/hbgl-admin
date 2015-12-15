require_relative '../test_helper'

describe Organization do
  subject { organization }

  describe 'partial_dup' do
    it 'should correctly duplicate an organization' do
      organization = FactoryGirl.create :organization, :approved
      duplicate = organization.partial_dup
      duplicate.name.must_equal nil
      duplicate.founded.must_equal nil
      duplicate.aasm_state.must_equal 'initialized'
    end
  end
end
