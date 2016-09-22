# frozen_string_literal: true
require_relative '../../test_helper'

class WeeklyStatisticAggregatorTest < ActiveSupport::TestCase # to get fixtures
  subject { Statistic::WeeklyStatisticAggregator }
  let(:object) { subject.new(1, 2222, 33, 4) }
  let(:spec_attrs) do
    {
      user_team_id: 1, model: 'SomeModel', field_name: 'field',
      field_start_value: 4, field_end_value: 5
    }
  end
  let(:spec_goal_key) { [1, 'SomeModel', 'field', 4, 5] }
  let(:now) { Date.current }

  describe '#record!' do
    it 'should create a weekly statistic for every unique goal key set' do
      Statistic.where(time_frame: 'weekly').count.must_equal 0
      Statistic.create!(
        spec_attrs.merge(date: now, user_id: 1, count: 1))
      Statistic.create!(spec_attrs.merge(date: now, user_id: 1, count: 3))
      Statistic.create!(spec_attrs.merge(date: now, user_id: 1, count: 5, field_name: 'other'))
      Statistic.create!(spec_attrs.merge(date: now, user_id: 1, count: 7, model: 'foo'))
      subject.new(1, now.year, now.cweek, 10).record!
      weeklies = Statistic.where(time_frame: 'weekly')
      weeklies.count.must_equal 3
      weeklies[0].count.must_equal 0.4
      weeklies[1].count.must_equal 0.5
      weeklies[2].count.must_equal 0.7
    end
  end

  describe '#all_statistics_from_week' do
    it 'should fetch all statistics in a certain time frame' do
      week = now.all_week
      found1 = Statistic.create!(spec_attrs.merge(date: week.first, user_id: 1))
      found2 = Statistic.create!(spec_attrs.merge(date: week.last, user_id: 1))
      Statistic.create!(spec_attrs.merge(date: week.last + 1.day, user_id: 1))
      Statistic.create!(spec_attrs.merge(date: week.first - 1.week, user_id: 1))
      subject.new(1, now.year, now.cweek, 0).send(:all_statistics_from_week)
             .must_equal([found1, found2])
    end
  end

  describe '#sorted_statistics_from_week' do
    it 'should sort all_statistics_from_week by their unique goal key' do
      bar = OpenStruct.new(spec_attrs.merge(foo: 'bar'))
      baz = OpenStruct.new(spec_attrs.merge(foo: 'baz'))
      fuz = OpenStruct.new(spec_attrs.merge(foo: 'fuz', model: 'Other'))
      object.expects(:all_statistics_from_week).returns([bar, baz, fuz])
      object.send(:sorted_statistics_from_week).must_equal(
        spec_goal_key => [bar, baz],
        [1, 'Other', 'field', 4, 5] => [fuz]
      )
    end
  end

  describe '#serialize_goal_unique_key' do
    it 'should convert an object to a certain array' do
      object.send(:serialize_goal_unique_key, OpenStruct.new(spec_attrs))
            .must_equal spec_goal_key
    end
  end

  describe '#deserialize_goal_unique_key' do
    it 'should convert an array to a certain hash' do
      object.send(:deserialize_goal_unique_key, spec_goal_key)
            .must_equal(spec_attrs)
    end
  end
end
