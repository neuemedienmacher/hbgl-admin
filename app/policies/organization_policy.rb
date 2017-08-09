# frozen_string_literal: true
class OrganizationPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    true
  end

  def change_state?
    true
  end
end
