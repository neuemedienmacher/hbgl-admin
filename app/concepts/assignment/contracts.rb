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
    validate :receiver_or_receiver_team_id_must_be_present

    def receiver_or_receiver_team_id_must_be_present
      return if receiver_id.present? || receiver_team_id.present?
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
