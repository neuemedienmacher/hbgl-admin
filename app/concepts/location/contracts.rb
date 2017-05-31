# frozen_string_literal: true
module Location::Contracts
  class Create < Reform::Form
    property :name
    property :street
    property :addition
    property :zip
    property :display_name
    property :city_id
    property :organization_id
    property :federal_state_id
    property :in_germany
    property :hq
    property :visible

    validates :name, length: { maximum: 100 }
    validates :street, presence: true,
                       format: /\A.+\d*.*\z/ # optional digit for house number
    validates :addition, length: { maximum: 255 }
    validates :zip, presence: true, length: { is: 5 },
                    if: ->(location) { location.in_germany }
    # validates :display_name, presence: true

    validates :city_id, presence: true
    validates :organization_id, presence: true
    validates :federal_state_id, presence: true
  end

  class Update < Create
    validates :display_name, presence: true
  end
end
