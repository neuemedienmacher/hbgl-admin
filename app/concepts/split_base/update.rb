# frozen_string_literal: true
class SplitBase::Update < Trailblazer::Operation
  step Model(::SplitBase, :find_by)
  step Policy::Pundit(SplitBasePolicy, :update?)

  step Contract::Build(constant: SplitBase::Contracts::Update)
  step Contract::Validate()
  step Wrap(::Lib::Transaction) {
    step ::Lib::Macros::Nested::Find(:divisions, ::Division)
    step ::Lib::Macros::Nested::Find(:solution_category, ::SolutionCategory)
  }
  step Contract::Persist()
end
