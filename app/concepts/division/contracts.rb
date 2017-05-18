# frozen_string_literal: true
module Division::Contracts
  class Create < Reform::Form
    property :name
    property :organization
    property :section
    property :presumed_categories
    property :presumed_solution_categories
    property :comment
    property :size

    validates :name, presence: true
    validates :organization, presence: true
    validates :section, presence: true
  end
end
