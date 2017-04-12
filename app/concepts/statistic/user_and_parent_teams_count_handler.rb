# frozen_string_literal: true
# PORO that handles counting up of all affected statistics (including all
# weekly statistics of all parent_teams)
class Statistic::UserAndParentTeamsCountHandler
  def self.record user, model, field_name, old_value, new_value
    Statistic.transaction do
      # increase user-statistics
      Statistic::CountHandler.record(
        user, model, field_name, old_value, new_value
      )
      # grab affectedUserIds
      affected_uniq_teams = user.user_teams.map do |team|
        recursive_parent_teams(team)
      end.flatten.uniq
      # iterate uniq parent_teams and increase their team-statistics as well.
      # does not increase a value of a parent_team by more than one!
      affected_uniq_teams.map do |team|
        Statistic::CountHandler.record(
          team, model, field_name, old_value, new_value
        )
      end
    end
  end

  # returns an array of all parent_teams of the given ream
  def self.recursive_parent_teams team
    [team] + (team.parent_id ? recursive_parent_teams(team.parent) : [])
  end
end
