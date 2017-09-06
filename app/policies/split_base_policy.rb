# frozen_string_literal: true
class SplitBasePolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    true
  end
end
