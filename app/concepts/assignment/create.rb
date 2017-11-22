# frozen_string_literal: true

class Assignment::Create < Trailblazer::Operation
  include Assignable::CommonSideEffects::CreateNewAssignment

  step Model(Assignment, :new)
  # step :decorate_assignable
  step Policy::Pundit(AssignmentPolicy, :create?)
  step Contract::Build(constant: Assignment::Contracts::Create)
  step Contract::Validate()
  step :set_current_user_to_creator_if_empty
  step :close_open_assignments!
  step Contract::Persist()
  step :reset_translation_if_returned_to_system_user
  step :create_optional_assignment_for_organization!
  step ::Lib::Macros::Live::SendCreation()
  step :send_current_assignment_changes

  # def decorate_assignable(options, model:, **)
  #   options['model'] = ::Assignable::Twin.new(model)
  # end

  def set_current_user_to_creator_if_empty(options, current_user:, **)
    if options['contract.default'].creator_id
      true
    else
      options['contract.default'].creator_id = current_user.id
    end
  end

  def close_open_assignments! options
    type = options['contract.default'].assignable_type
    id = options['contract.default'].assignable_id
    ::Assignment.where(assignable_id: id).where(assignable_type: type)
                .where(aasm_state: 'open').update_all aasm_state: 'closed'
  end

  def reset_translation_if_returned_to_system_user(_options, model:, **)
    sys_user_id = User.system_user.id
    if model.receiver_id == sys_user_id && model.creator_id != sys_user_id &&
       %w[OfferTranslation OrganizationTranslation].include?(
         model.assignable_type
       ) &&
       model.created_by_system == false
      model.assignable.update_columns(
        source: 'researcher', possibly_outdated: false
      )
    end
    true
  end

  def send_current_assignment_changes(_, model:, **)
    ::Lib::Macros::Live.broadcast_change(
      model.assignable,
      'current-assignment-id' => model.id, 'assignment-ids' => [model.id]
    )
    true
  end
end
