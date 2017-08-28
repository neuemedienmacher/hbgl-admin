# frozen_string_literal: true
class SolutionCategory::Create < Trailblazer::Operation
  step Model(::SolutionCategory, :new)
  step Policy::Pundit(SolutionCategoryPolicy, :create?)

  step Contract::Build(constant: SolutionCategory::Contracts::Create)
  step Contract::Validate()
  step Wrap(::Lib::Transaction) {
    step ::Lib::Macros::Nested::Find(
      :parent, ::SolutionCategory
    )
  }
  step Contract::Persist()
end
