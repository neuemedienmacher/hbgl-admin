# frozen_string_literal: true
require_relative '../../test_helper'

class DailyTeamStatisticSynchronizerTest < ActiveSupport::TestCase
  subject { Statistic::DailyTeamStatisticSynchronizer }
  # let(:object) { subject.new(1, 2222) }
  let(:spec_attrs) do
    {
      model: 'SomeModel', field_name: 'SomeField',
      field_start_value: 'SomeStart', field_end_value: 'SomeEnd'
    }
  end
  # let(:spec_goal_key) { ['SomeModel', 'field', 4, 5] }
  let(:now) { Date.current }

  describe '#record!' do
    it 'should create an aggregated team_statistic for summable data' do
      Statistic.where(trackable_type: 'UserTeam').count.must_equal 0

      UserTeam.find(1).users = User.where(id: [1, 2])
      Statistic.create!(spec_attrs.merge(date: now, trackable_id: 1, trackable_type: 'User', count: 1))
      Statistic.create!(spec_attrs.merge(date: now, trackable_id: 2, trackable_type: 'User', count: 3))

      subject.new(1, now.year).record!
      team_statistics = Statistic.where(trackable_type: 'UserTeam')
      team_statistics.count.must_equal 1
      team_statistics.first.count.must_equal 4.0
    end

    it 'should create two team_statistics for different days' do
      Statistic.where(trackable_type: 'UserTeam').count.must_equal 0

      UserTeam.find(1).users = User.where(id: [1, 2])
      Statistic.create!(spec_attrs.merge(date: now, trackable_id: 1, trackable_type: 'User', count: 1))
      Statistic.create!(spec_attrs.merge(date: now + 1.day, trackable_id: 2, trackable_type: 'User', count: 3))
      Statistic.create!(spec_attrs.merge(date: now + 2.days, trackable_id: 2, trackable_type: 'User', count: 7))

      subject.new(1, now.year).record!
      team_statistics = Statistic.where(trackable_type: 'UserTeam')
      team_statistics.count.must_equal 3
      team_statistics[0].count.must_equal 1.0
      team_statistics[1].count.must_equal 3.0
      team_statistics[2].count.must_equal 7.0
    end

    it 'should ignore a statistic of a user that is not in the team' do
      Statistic.where(trackable_type: 'UserTeam').count.must_equal 0

      UserTeam.find(1).users = User.where(id: 1)
      Statistic.create!(spec_attrs.merge(date: now, trackable_id: 1, trackable_type: 'User', count: 1))
      Statistic.create!(spec_attrs.merge(date: now, trackable_id: 2, trackable_type: 'User', count: 3))

      subject.new(1, now.year).record!
      team_statistics = Statistic.where(trackable_type: 'UserTeam')
      team_statistics.count.must_equal 1
      team_statistics.first.count.must_equal 1.0
    end

    it 'should ignore non-daily statistics' do
      Statistic.where(trackable_type: 'UserTeam').count.must_equal 0

      UserTeam.find(1).users = User.where(id: [1, 2])
      Statistic.create!(spec_attrs.merge(date: now, trackable_id: 1, trackable_type: 'User', count: 1))
      Statistic.create!(spec_attrs.merge(date: now, trackable_id: 2, trackable_type: 'User', count: 3, time_frame: 'weekly'))

      subject.new(1, now.year).record!
      team_statistics = Statistic.where(trackable_type: 'UserTeam')
      team_statistics.count.must_equal 1
      team_statistics.first.count.must_equal 1.0
    end

    it 'should create two seperate statistics for different models' do
      Statistic.where(trackable_type: 'UserTeam').count.must_equal 0

      UserTeam.find(1).users = User.where(id: [1, 2])
      Statistic.create!(spec_attrs.merge(date: now, trackable_id: 1, trackable_type: 'User', count: 42))
      Statistic.create!(spec_attrs.merge(date: now, trackable_id: 2, trackable_type: 'User', count: 3, model: 'SomeOtherModel'))

      subject.new(1, now.year).record!
      team_statistics = Statistic.where(trackable_type: 'UserTeam')
      team_statistics.count.must_equal 2
      team_statistics.where(model: 'SomeModel').first.count.must_equal 42.0
      team_statistics.where(model: 'SomeOtherModel').first.count.must_equal 3.0
    end

    it 'should create two seperate statistics for different field_names' do
      Statistic.where(trackable_type: 'UserTeam').count.must_equal 0

      UserTeam.find(1).users = User.where(id: [1, 2])
      Statistic.create!(spec_attrs.merge(date: now, trackable_id: 1, trackable_type: 'User', count: 42))
      Statistic.create!(spec_attrs.merge(date: now, trackable_id: 2, trackable_type: 'User', count: 3, field_name: 'SomeOtherField'))

      subject.new(1, now.year).record!
      team_statistics = Statistic.where(trackable_type: 'UserTeam')
      team_statistics.count.must_equal 2
      team_statistics.where(field_name: 'SomeField').first.count.must_equal 42.0
      team_statistics.where(field_name: 'SomeOtherField').first.count.must_equal 3.0
    end

    it 'should create two team_statistics for different days and then delete '\
       'one if a user moved to a different team' do
      Statistic.where(trackable_type: 'UserTeam').count.must_equal 0

      UserTeam.find(1).users = User.where(id: [1, 2])
      Statistic.create!(spec_attrs.merge(date: now, trackable_id: 1, trackable_type: 'User', count: 1))
      Statistic.create!(spec_attrs.merge(date: now, trackable_id: 2, trackable_type: 'User', count: 3))
      Statistic.create!(spec_attrs.merge(date: now + 1.day, trackable_id: 2, trackable_type: 'User', count: 7))

      subject.new(1, now.year).record!
      team_statistics = Statistic.where(trackable_type: 'UserTeam')
      team_statistics.count.must_equal 2
      team_statistics.first.count.must_equal 4.0
      team_statistics.last.count.must_equal 7.0

      # remove user #2 from UserTeam and sync again to test delete mechanic
      to_delete = team_statistics.last
      UserTeam.find(1).users = User.where(id: 1)
      subject.new(1, now.year).record!
      team_statistics = Statistic.where(trackable_type: 'UserTeam')
      team_statistics.count.must_equal 1
      team_statistics.first.count.must_equal 1.0
      assert_raises(ActiveRecord::RecordNotFound) { to_delete.reload }
    end
  end

  # describe '#all_statistics_from_week' do
  #   it 'should fetch all statistics in a certain time frame' do
  #     week = now.all_week
  #     found1 = Statistic.create!(spec_attrs.merge(date: week.first, trackable_id: 1, trackable_type: 'User'))
  #     found2 = Statistic.create!(spec_attrs.merge(date: week.last, trackable_id: 1, trackable_type: 'User'))
  #     Statistic.create!(spec_attrs.merge(date: week.last + 1.day, trackable_id: 1, trackable_type: 'User'))
  #     Statistic.create!(spec_attrs.merge(date: week.first - 1.week, trackable_id: 1, trackable_type: 'User'))
  #     subject.new(1, now.year, now.cweek, 0).send(:all_statistics_from_week)
  #            .must_equal([found1, found2])
  #   end
  # end
  #
  # describe '#sorted_statistics_from_week' do
  #   it 'should sort all_statistics_from_week by their unique goal key' do
  #     bar = OpenStruct.new(spec_attrs.merge(foo: 'bar'))
  #     baz = OpenStruct.new(spec_attrs.merge(foo: 'baz'))
  #     fuz = OpenStruct.new(spec_attrs.merge(foo: 'fuz', model: 'Other'))
  #     object.expects(:all_statistics_from_week).returns([bar, baz, fuz])
  #     object.send(:sorted_statistics_from_week).must_equal(
  #       spec_goal_key => [bar, baz],
  #       ['Other', 'field', 4, 5] => [fuz]
  #     )
  #   end
  # end
  #
  # describe '#serialize_goal_unique_key' do
  #   it 'should convert an object to a certain array' do
  #     object.send(:serialize_goal_unique_key, OpenStruct.new(spec_attrs))
  #           .must_equal spec_goal_key
  #   end
  # end
  #
  # describe '#deserialize_goal_unique_key' do
  #   it 'should convert an array to a certain hash' do
  #     object.send(:deserialize_goal_unique_key, spec_goal_key)
  #           .must_equal(spec_attrs)
  #   end
  # end
end
