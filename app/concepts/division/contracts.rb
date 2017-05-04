# frozen_string_literal: true
module Division::Contracts
  class Create < Reform::Form
    property :name
    property :organization_id
    property :section_id
    property :presumed_category_ids
    property :presumed_solution_category_ids
    property :comment
    property :size

    validates :name, presence: true
    validates :organization_id, presence: true
    validates :section_id, presence: true
  end
end
