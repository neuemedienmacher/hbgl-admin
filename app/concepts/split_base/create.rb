# frozen_string_literal: true

class SplitBase::Create < Trailblazer::Operation
  step Model(::SplitBase, :new)
  step Policy::Pundit(SplitBasePolicy, :create?)

  step Contract::Build(constant: SplitBase::Contracts::Create)
  step Contract::Validate()
  step Wrap(::Lib::Transaction) {
    step ::Lib::Macros::Nested::Find(:divisions, ::Division)
    step ::Lib::Macros::Nested::Find(:solution_category, ::SolutionCategory)
  }
  step Contract::Persist()
end
