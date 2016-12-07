class AssignmentPolicy < ApplicationPolicy
  def create?
    user.role == 'super' || user.role == 'researcher'
  end

  def update?
    user.user_teams.pluck(:id).include?(record.reciever_team_id)
  end
end
