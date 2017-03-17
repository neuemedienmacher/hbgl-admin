# frozen_string_literal: true
class AssignmentPolicy < ApplicationPolicy
  def create?
    user && (user.role == 'super' || user.role == 'researcher')
  end

  def update?
    user # && user.user_teams.pluck(:id).include?(record.receiver_team_id)
  end
end
