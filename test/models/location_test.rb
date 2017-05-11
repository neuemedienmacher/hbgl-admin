# frozen_string_literal: true
require_relative '../test_helper'

describe Location do
  subject { Location.new }

  describe 'partial_dup' do
    it 'should correctly duplicate an location' do
      location = FactoryGirl.create :location, :hq
      duplicate = location.partial_dup
      duplicate.hq.must_equal false
      duplicate.offers.must_equal []
      duplicate.organization.must_equal location.organization
      duplicate.federal_state.must_equal location.federal_state
    end
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_length_of(:name).is_at_most 100 }
      it { subject.must validate_presence_of :street }
      it { subject.must validate_presence_of :zip }
      it { subject.must validate_length_of(:zip).is_equal_to 5 }
      it { subject.must validate_presence_of :city_id }
      it { subject.must validate_presence_of :organization_id }
      it { subject.must validate_presence_of :federal_state_id }
    end

    describe 'when location is not in germany' do
      before do
        # valid location in germany
        subject.assign_attributes street: 'street 1',
                                  city_id: 1,         # fixture City
                                  organization_id: 1, # fixture Orga
                                  federal_state_id: 1 # fixture federal_state
      end

      it 'should allow any zip length' do
        subject.assign_attributes zip: '123456-789'
        subject.valid?.must_equal false
        subject.assign_attributes in_germany: false
        subject.valid?.must_equal true
      end

      it 'should be okay with a missing federal_state_id' do
        subject.assign_attributes federal_state_id: nil
        subject.valid?.must_equal false
        subject.assign_attributes in_germany: false
        subject.valid?.must_equal true
      end
    end
  end

  describe 'methods' do
    describe '#generate_display_name' do
      before do
        subject.assign_attributes street: 'street',
                                  zip: 'zip',
                                  city_id: 1,         # fixture City
                                  organization_id: 1  # fixture Orga
      end

      it 'should show the basic info if nothing else exists' do
        subject.display_name.must_be_nil
        subject.generate_display_name
        subject.display_name.must_equal 'foobar | street zip Berlin'
      end

      it 'should show the location name if one exists' do
        subject.name = 'name'
        subject.generate_display_name
        subject.display_name.must_equal 'foobar, name | street zip Berlin'
      end

      it 'should show the addition if one exists' do
        subject.addition = 'addition'
        subject.generate_display_name
        subject.display_name.must_equal 'foobar | street, addition, zip Berlin'
      end

      it 'should show name & addition if both exist' do
        subject.name = 'name'
        subject.addition = 'addition'
        subject.generate_display_name
        subject.display_name.must_equal 'foobar, name | street, addition, zip Berlin'
      end
    end
  end
end
