# frozen_string_literal: true
module API::V1
  module SolutionCategory
    class Create < ::SolutionCategory::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::SolutionCategory::Representer::Create
    end
  end
end
