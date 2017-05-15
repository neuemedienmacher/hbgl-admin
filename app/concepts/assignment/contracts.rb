# frozen_string_literal: true
module Assignment::Contracts
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

    validates :receiver_id, numericality: true, allow_blank: true
  end
end
