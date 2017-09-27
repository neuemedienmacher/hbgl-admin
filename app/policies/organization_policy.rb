# frozen_string_literal: true
class OrganizationPolicy < ApplicationPolicy
  def change_state?
    true
  end
end
