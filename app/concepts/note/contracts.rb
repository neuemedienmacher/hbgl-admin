# frozen_string_literal: true

module Note::Contracts
  class Create < Reform::Form
    property :text
    property :topic
    property :notable
    property :user

    validates :text, presence: true, length: { maximum: 800 }
    validates :topic, presence: true
    validates :notable, presence: true
    validates :user, presence: true
  end
end
