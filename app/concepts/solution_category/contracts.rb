# frozen_string_literal: true
module SolutionCategory::Contracts
  class Create < Reform::Form
    property :name
    property :parent

    validates :name, presence: true
  end

  class Update < Create
  end
end
