# frozen_string_literal: true
class TimeAllocationPolicy < ApplicationPolicy
  def create?
    @user.role == 'super'
  end

  def update?
    create?
  end

  def report_actual?
    @record.user == @user
  end
end
