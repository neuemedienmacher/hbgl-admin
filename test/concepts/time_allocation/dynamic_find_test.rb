# frozen_string_literal: true
require_relative '../../test_helper'
class TimeAllocationDynamicFindTest < ActiveSupport::TestCase # to have fixtures
  subject { API::V1::TimeAllocation::DynamicFind }

  describe '#find_or_initialize' do
    let(:finder) { subject.new(users(:researcher).id, 1234, 5) }
    it 'should find an existing time allocation' do
      allocation = TimeAllocation.create!(
        year: 1234, week_number: 5, user_id: users(:researcher).id,
        desired_wa_hours: 1
      )
      # Decoy
      TimeAllocation.create!(
        year: 1234, week_number: 3, user_id: users(:researcher).id,
        desired_wa_hours: 2
      )
      finder.find_or_initialize.must_equal allocation
    end

    it 'should initialize an allocation based on the closest previous one' do
      TimeAllocation.create!(
        year: 1234, week_number: 3, user_id: users(:researcher).id,
        desired_wa_hours: 1
      )
      # Decoy
      TimeAllocation.create!(
        year: 1000, week_number: 5, user_id: users(:researcher).id,
        desired_wa_hours: 2
      )
      found = finder.find_or_initialize
      found.new_record?.must_equal true
      found.attributes.must_equal(
        'year' => 1234, 'week_number' => 5, 'user_id' => 1,
        'desired_wa_hours' => 1, 'actual_wa_hours' => nil, 'id' => nil,
        'actual_wa_comment' => nil
      )
    end

    it 'should throw an error when there are no matches' do
      # Decoy
      TimeAllocation.create!(
        year: 1234, week_number: 6, user_id: users(:researcher).id,
        desired_wa_hours: 1
      )
      assert_raises(subject::NoHistoricalMatchError) do
        finder.find_or_initialize.must_equal allocation
      end
    end
  end
end
