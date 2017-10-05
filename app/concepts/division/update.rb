# frozen_string_literal: true
class Division::Update < Trailblazer::Operation
  include SyncOrganization

  step Model(::Division, :find_by)
  step Policy::Pundit(PermissivePolicy, :update?)

  step Contract::Build(constant: Division::Contracts::Update)
  step Contract::Validate()
  step Wrap(::Lib::Transaction) {
    step ::Lib::Macros::Nested::Create(:websites, Website::Create)
    step ::Lib::Macros::Nested::Find(:section, ::Section)
    step ::Lib::Macros::Nested::Find(:city, ::City)
    step ::Lib::Macros::Nested::Find(:area, ::Area)
    step ::Lib::Macros::Nested::Find(:organization, ::Organization)
    step ::Lib::Macros::Nested::Find(:presumed_categories, ::Category)
    step ::Lib::Macros::Nested::Find(
      :presumed_solution_categories, ::SolutionCategory
    )
  }
  step Contract::Persist()
  step :meta_event_side_effects
  step :syncronize_organization_approve_or_done_state

  def meta_event_side_effects(_, model:, params:, current_user:, **)
    action_event = params['meta'] ? params['meta']['commit'] : nil
    return true unless action_event
    if action_event == 'mark_as_done'
      ::Division::MarkAsDone.(
        {}, divison: model, last_acting_user: current_user
      ).success?
    elsif action_event == 'mark_as_not_done'
      model.update_columns done: false
    end
    true
  end
end
