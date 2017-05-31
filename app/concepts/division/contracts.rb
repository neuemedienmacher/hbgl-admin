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
    validates :organization, presence: true
    validates :section, presence: true

    include ::NestedValidation
    validate_nested_collection :websites, Website::Contracts::Create
  end
end
