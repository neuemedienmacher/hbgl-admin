# frozen_string_literal: true

# KK: Do we really need this separately from Update?
class Organization::ChangeState < Trailblazer::Operation
  step Model(::Organization, :find_by)
  step Policy::Pundit(PermissivePolicy, :change_state?)

  step ::Lib::Macros::State::Contract(
    approve: Organization::Contracts::Approve,
    else: Organization::Contracts::Update
  )
  step Contract::Build()
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
