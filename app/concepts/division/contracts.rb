# frozen_string_literal: true
module Division::Contracts
  class Create < Reform::Form
    property :name
    property :organization
    property :websites
    property :section
    property :presumed_categories
    property :presumed_solution_categories
    property :comment
    property :size

    validates :name, presence: true
    validate ::Lib::Validators::UnnestedPresence :organization
    validates :section, presence: true
  end

  class Update < Create
    # update-specific validations?
  end
end
