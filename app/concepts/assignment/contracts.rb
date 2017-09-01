# frozen_string_literal: true
module Assignment::Contracts
  class Create < Reform::Form
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
    # validates :topic, presence: true
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
    validate :receiver_or_receiver_team_id_must_be_present

    def receiver_or_receiver_team_id_must_be_present
      return if !receiver_id.blank? || !receiver_team_id.blank?
      errors.add :receiver_id, 'Nutzer oder Team muss gesetzt sein'
      errors.add :receiver_team_id, 'Nutzer oder Team muss gesetzt sein'
    end
  end

  class Update < Reform::Form
    property :id, writeable: false
    property :assignable_id
    property :assignable_type
    property :creator_id
    property :creator_team_id
    property :receiver_id
    property :receiver_team_id
    property :message
    property :aasm_state
    property :topic

    validates :receiver_id, numericality: true, allow_blank: true
  end
end
