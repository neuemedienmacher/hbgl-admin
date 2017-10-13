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
  step :generate_label # TODO: write tests for this!!
  step Contract::Persist()

  def generate_label(options, model:, **)
    contr = options['contract.default']
    label = "#{contr.title} (id: not yet available"
    label += ", D: #{contr.divisions.map(&:label)}" if contr.divisions.any?
    label += ", SC: #{contr.solution_category.name})" if contr.solution_category
    model.label = label
  end
end
