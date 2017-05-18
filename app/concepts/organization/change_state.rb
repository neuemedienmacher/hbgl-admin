# frozen_string_literal: true
class Organization::ChangeState < Trailblazer::Operation
  step Model(::Organization, :find_by)
  step Policy::Pundit(OrganizationPolicy, :change_state?)

  step Contract::Build(constant: Organization::Contracts::ChangeState)
  step Contract::Validate()
  step :send_event!

  step :generate_translations!

  def send_event!(_, model:, event:, **)
    model.send :"#{event}!"
  end

  def generate_translations!(_, model:, **)
    model.generate_translations!
  end
end
