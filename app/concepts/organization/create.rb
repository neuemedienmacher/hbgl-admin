# frozen_string_literal: true
class Organization::Create < Trailblazer::Operation
  step Model(::Organization, :new)
  step Policy::Pundit(OrganizationPolicy, :create?)

  step Contract::Build(constant: Organization::Contracts::Create)
  step Contract::Validate()
  step :set_creating_user
  step Contract::Persist()

  def set_creating_user(_, current_user:, model:, **)
    model.created_by = current_user.id
  end
end
