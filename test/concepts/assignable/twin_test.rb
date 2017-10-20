# frozen_string_literal: true

require_relative '../../test_helper'

class Assignable::TwinTest < ActiveSupport::TestCase
  let(:subject) { Assignable::Twin.new(offer_translations(:de)) }
  let(:faked_assignable) { OpenStruct.new(assignments: []) }

  describe 'should_be_created_by_system?' do
    it 'should be true for de-translation' do
      subject.should_be_created_by_system?.must_equal true
    end

    it 'should be false for faked assignable' do
      user_twin = Assignable::Twin.new(faked_assignable)
      user_twin.should_be_created_by_system?.must_equal false
    end
  end

  describe 'should_create_new_assignment?' do
    it 'should be false for de-translation' do
      subject.should_create_new_assignment?.must_equal false
    end

    it 'should be false for undone-division' do
      subject = Assignable::Twin.new(FactoryGirl.create(:division))
      subject.should_create_new_assignment?.must_equal false
    end

    it 'should be false for faked assignable' do
      user_twin = Assignable::Twin.new(faked_assignable)
      user_twin.should_create_new_assignment?.must_equal false
    end
  end

  describe 'assigned_to_system?' do
    it 'should be false for default de-translation' do
      subject.assigned_to_system?.must_equal false
    end

    it 'should be true when assigned to system_user' do
      ot = offer_translations(:de)
      ot.assignments.first.update_columns receiver_id: User.system_user.id
      subject = Assignable::Twin.new(ot)
      subject.assigned_to_system?.must_equal true
    end
  end
end
