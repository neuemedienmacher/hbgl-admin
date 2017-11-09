# frozen_string_literal: true

require_relative '../../test_helper'
# to have fixtures
class UserAndParentTeamsCountHandlerTest < ActiveSupport::TestCase
  subject { Statistic::UserAndParentTeamsCountHandler }

  describe '#record' do
    it 'must create a two statistics for a simple user in a non-parent team' do
      user = User.first
      user.user_teams = [UserTeam.first]

      Statistic.count.must_equal 0
      subject.record user, 'Offer', 'aasm_state', 'initialized', 'completed'
      Statistic.count.must_equal 2

      stat = Statistic.order(:id).first # WTF?
      stat.trackable_id.must_equal user.id
      stat.trackable_type.must_equal 'User'
      stat.date.wont_be :nil?
      stat.model.must_equal 'Offer'
      stat.field_name.must_equal 'aasm_state'
      stat.field_start_value.must_equal 'initialized'
      stat.field_end_value.must_equal 'completed'
      stat.count.must_equal 1

      stat = Statistic.order(:id).last # WTF?
      stat.trackable_id.must_equal user.user_teams.first.id
      stat.trackable_type.must_equal 'UserTeam'
      stat.date.wont_be :nil?
      stat.model.must_equal 'Offer'
      stat.field_name.must_equal 'aasm_state'
      stat.field_start_value.must_equal 'initialized'
      stat.field_end_value.must_equal 'completed'
      stat.count.must_equal 1
    end

    it 'must create a statistic for a the user and each parent-team' do
      user = User.first
      UserTeam.second.update_columns parent_id: UserTeam.first.id
      user.user_teams = [UserTeam.second]

      Statistic.count.must_equal 0
      subject.record user, 'Offer', 'aasm_state', 'initialized', 'completed'
      Statistic.count.must_equal 3

      Statistic.where(trackable_type: 'User').count.must_equal 1
      stat = Statistic.where(trackable_type: 'User').first
      stat.trackable_id.must_equal user.id
      stat.trackable_type.must_equal 'User'
      stat.count.must_equal 1

      Statistic.where(trackable_type: 'UserTeam').count.must_equal 2
      stats = Statistic.where(trackable_type: 'UserTeam')
      stats.pluck(:trackable_id).include?(UserTeam.first.id).must_equal true
      stats.pluck(:trackable_id).include?(UserTeam.second.id).must_equal true
      stats.pluck(:count).must_equal [1, 1]
    end

    it 'wont count statistics double for diamond relations' do
      user = User.first
      UserTeam.second.update_columns parent_id: UserTeam.first.id
      another_team = UserTeam.create! name: 'Test', parent_id: UserTeam.first.id
      user.user_teams = [UserTeam.second, another_team]
      UserTeam.first.children.count.must_equal 2

      Statistic.count.must_equal 0
      subject.record user, 'Offer', 'aasm_state', 'initialized', 'completed'
      Statistic.count.must_equal 4

      Statistic.where(trackable_type: 'User').count.must_equal 1
      stat = Statistic.where(trackable_type: 'User').first
      stat.trackable_id.must_equal user.id
      stat.trackable_type.must_equal 'User'
      stat.count.must_equal 1

      Statistic.where(trackable_type: 'UserTeam').count.must_equal 3
      stats = Statistic.where(trackable_type: 'UserTeam')
      stats.pluck(:trackable_id).include?(UserTeam.first.id).must_equal true
      stats.pluck(:trackable_id).include?(UserTeam.second.id).must_equal true
      stats.pluck(:trackable_id).include?(another_team.id).must_equal true
      stats.pluck(:count).must_equal [1, 1, 1]
    end
  end
end
