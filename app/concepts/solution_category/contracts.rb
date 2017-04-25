# frozen_string_literal: true
module SolutionCategory::Contracts
  class Create < Reform::Form
    property :name

    validates :name, presence: true
  end
end
