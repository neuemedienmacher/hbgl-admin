# frozen_string_literal: true

module Location::Contracts
  class Create < Reform::Form
    property :name
    property :street
    property :addition
    property :zip
    # property :label
    property :city
    property :organization
    property :federal_state
    property :in_germany
    property :hq
    property :visible

    validates :name, length: { maximum: 100 }
    validates :street, presence: true,
                       format: /\A.+\d*.*\z/ # optional digit for house number
    validates :addition, length: { maximum: 255 }
    validates :zip, presence: true, length: { is: 5 },
                    if: ->(location) { location.in_germany }
    # validates :label, presence: true

    validates :city, presence: true
    validate ::Lib::Validators::UnnestedPresence :organization
    validates :federal_state, presence: true
  end

  class Update < Create
    # validates :label, presence: true
  end
end
