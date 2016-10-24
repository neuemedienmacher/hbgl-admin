class AssignmentPolicy < ApplicationPolicy
  def create?
    user.role == 'super'
  end

  def assign_and_edit_assignable?
    user.user_teams.pluck(:id).include?(record.reciever_team_id)
  end
end
