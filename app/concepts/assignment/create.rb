# frozen_string_literal: true
class Assignment::Create < Trailblazer::Operation
  include Assignable::CommonSideEffects::CreateNewAssignment

  step Model(Assignment, :new)
  # step :decorate_assignable
  step Policy::Pundit(AssignmentPolicy, :create?)
  step Contract::Build()
  step Contract::Validate()
  step :set_current_user_to_creator_if_empty
  step :close_open_assignments!
  step Contract::Persist()
  step :reset_translation_if_returned_to_system_user
  step :create_optional_assignment_for_organization!
  step :optional_set_done_for_division_and_mark_orga_as_done

  extend Contract::DSL
  contract do
    property :assignable_id
    property :assignable_type
    property :assignable_field_type
    property :creator_id
    property :creator_team_id
    property :receiver_id
    property :receiver_team_id
    property :message
    property :parent_id
    property :aasm_state
    property :created_at
    property :updated_at
    property :topic
    property :created_by_system

    # TODO: check if model instance exists!! here or somewhere else?!
    validates :assignable_id, presence: true, numericality: true
    validates :assignable_type, presence: true
    # validates :assignable_field_type, presence: true # TODO: force empty string?!
    # uniqueness validation: make sure there is only one open assignment
    # w/o a parent (base assignment) per assignable model & field
    # validates_uniqueness_of :assignable_id, scope: [:assignable_type, :assignable_field_type], conditions: -> { where(aasm_state: 'open').where(parent_id: nil) }
    # validates_uniqueness_of :assignable_type, scope: [:assignable_id, :assignable_field_type], conditions: -> { where(aasm_state: 'open').where(parent_id: nil) }
    # validates_uniqueness_of :assignable_field_type, scope: [:assignable_type, :assignable_id], conditions: -> { where(aasm_state: 'open').where(parent_id: nil) }
    # creator or creator_team must be present
    # validates :creator_id, presence: true
    # validates :creator_team_id, presence: true, unless: :creator_id
    # receiver or receiver_team must be present
    validates :receiver_id, presence: true, unless: :receiver_team_id
    validates :receiver_team_id, presence: true, unless: :receiver_id
  end

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
       %w(OfferTranslation OrganizationTranslation).include?(model.assignable_type) &&
       model.created_by_system == false
      model.assignable.update_columns(
        source: 'researcher', possibly_outdated: false
      )
    end
    true
  end

  # TODO: remove this and call the operation on custom ActionButton of the model
  # rubocop:disable Metrics/AbcSize
  def optional_set_done_for_division_and_mark_orga_as_done(
    _options, model:, current_user:, **
  )
    sys_user_id = User.system_user.id
    if model.assignable_type == 'Division' && model.creator_id != sys_user_id &&
       model.receiver_id == sys_user_id
      # set divison to done
      model.assignable.update_columns(done: true)
      # update organization if this was the last undone division of it
      orga = model.assignable.organization
      if orga.divisions.where(done: false).empty? && orga.may_mark_as_done?
        orga.mark_as_done! # trigger event for callbacks
        ::Assignment::CreateBySystem.(
          {}, assignable: orga, last_acting_user: current_user
        ).success?
      end
    end
    true
  end
  # rubocop:enable Metrics/AbcSize
end
