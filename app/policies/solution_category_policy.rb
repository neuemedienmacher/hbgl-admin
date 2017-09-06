# frozen_string_literal: true
class SolutionCategoryPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    true
  end
end
