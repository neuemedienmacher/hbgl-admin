# frozen_string_literal: true
class Assignment::Create < Trailblazer::Operation
  step Model(Assignment, :new)
  # step :decorate_assignable
  step Policy::Pundit(AssignmentPolicy, :create?)
  step Contract::Build()
  step Contract::Validate()
  step :set_current_user_to_creator_if_empty
  step :optional_set_creator_team_to_creators_current_team_if_empty
  step :close_open_assignments!
  step Contract::Persist()

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

  def optional_set_creator_team_to_creators_current_team_if_empty(options)
    if options['contract.default'].creator_team_id.nil?
      options['contract.default'].creator_team_id =
        User.find(options['contract.default'].creator_id).current_team_id
    end
    true # If there is no current team, that's okay too.
  end

  def close_open_assignments! options
    type = options['contract.default'].assignable_type
    id = options['contract.default'].assignable_id
    ::Assignment.where(assignable_id: id).where(assignable_type: type)
                .where(aasm_state: 'open').update_all aasm_state: 'closed'
  end
end
