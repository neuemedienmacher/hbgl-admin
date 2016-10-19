class AssignmentPolicy < ApplicationPolicy
  # TODO: more Restrictions on edit/create (not just super-user)
  def create?
    user.role == 'super'
  end

  def update?
    create?
  end

  def assign_and_edit_assignable?
    true
  end
end
