# frozen_string_literal: true
class Division::Update < Trailblazer::Operation
  step Model(::Division, :find_by)
  step Policy::Pundit(DivisionPolicy, :update?)

  step Contract::Build(constant: Division::Contracts::Update)
  step Contract::Validate()
  step Contract::Persist()
  step :mark_as_done_side_effect

  def mark_as_done_side_effect(_, model:, params:, current_user:, **)
    action_event = params['meta'] ? params['meta']['commit'] : nil
    return true unless action_event && action_event == 'mark_as_done'
    ::Division::MarkAsDone.(
      {}, divison: model, last_acting_user: current_user
    ).success?
  end
end
