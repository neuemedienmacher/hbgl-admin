# frozen_string_literal: true
class Organization::ChangeState < Trailblazer::Operation
  step Model(::Organization, :find_by)
  step Policy::Pundit(OrganizationPolicy, :change_state?)

  step Contract::Build(constant: Organization::Contracts::ChangeState)
  step Contract::Validate()
  step :send_event!
  # Attention: This does not translate!

  def send_event!(options, model:, event:, **)
    if model.respond_to?("may_#{event}?") && model.send("may_#{event}?")
      model.send :"#{event}!"
    else
      options['contract.default'].errors.add(
        :base, "Event `#{event}` couldn't be processed"
      )
      false
    end
  end
end
