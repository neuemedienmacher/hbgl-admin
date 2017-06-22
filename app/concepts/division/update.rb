# frozen_string_literal: true
class Division::Update < Trailblazer::Operation
  step Model(::Division, :find_by)
  step Policy::Pundit(DivisionPolicy, :update?)

  step Contract::Build(constant: Division::Contracts::Update)
  step Contract::Validate()
  step Contract::Persist()
  step :meta_event_side_effects

  def meta_event_side_effects(_, model:, params:, current_user:, **)
    action_event = params['meta'] ? params['meta']['commit'] : nil
    return true unless action_event
    if action_event == 'mark_as_done'
      ::Division::MarkAsDone.(
        {}, divison: model, last_acting_user: current_user
      ).success?
    elsif action_event == 'mark_as_not_done'
      model.update_columns done: false
      if model.organization.all_done?
        model.organization.update_columns(aasm_state: 'approved')
      end
    end
    true
  end
end
