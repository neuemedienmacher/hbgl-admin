# frozen_string_literal: true
class Division::Create < Trailblazer::Operation
  include Assignable::CommonSideEffects::CreateNewAssignment

  step Model(::Division, :new)
  step Policy::Pundit(DivisionPolicy, :create?)

  step Contract::Build(constant: Division::Contracts::Create)
  step Contract::Validate()
  step Wrap(::Lib::Transaction) {
    step ::Lib::Macros::Nested::Create(:websites, Website::Create)
    step ::Lib::Macros::Nested::Find(:section, ::Section)
    step ::Lib::Macros::Nested::Find(:organization, ::Organization)
    step ::Lib::Macros::Nested::Find(:presumed_categories, ::Category)
    step ::Lib::Macros::Nested::Find(
      :presumed_solution_categories, ::SolutionCategory
    )
  }
  step Contract::Persist()
  step :create_initial_assignment!
  step :reset_organization_to_approved_when_it_is_done

  # new Division are (per definition) not done, so we reset the organization
  # to approved if it is already existing & all_done (all divisions are done)
  def reset_organization_to_approved_when_it_is_done(_options, model:, **)
    organization = ::Organization.where(id: model.organization_id).first
    if organization && organization.all_done?
      organization.update_columns(aasm_state: 'approved')
    end
    true
  end
end
