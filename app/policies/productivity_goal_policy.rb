class ProductivityGoalPolicy < ApplicationPolicy
  def create?
    user.role == 'super'
  end

  def update?
    create?
  end
end
