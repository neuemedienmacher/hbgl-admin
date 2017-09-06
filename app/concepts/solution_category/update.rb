# frozen_string_literal: true
class SolutionCategory::Update < Trailblazer::Operation
  step Model(::SolutionCategory, :find_by)
  step Policy::Pundit(SolutionCategoryPolicy, :update?)

  step Contract::Build(constant: SolutionCategory::Contracts::Update)
  step Contract::Validate()
  step Wrap(::Lib::Transaction) {
    step ::Lib::Macros::Nested::Find(
      :parent, ::SolutionCategory
    )
  }
  step Contract::Persist()
end
