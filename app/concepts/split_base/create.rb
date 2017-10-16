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
  step :generate_label!

  def generate_label!(options, model:, **)
    contr = options['contract.default']
    label = "#{contr.title} (id: #{model.id}"
    label += ", D: #{contr.divisions.map(&:label)}" if contr.divisions.any?
    label += ", SC: #{contr.solution_category.name})" if contr.solution_category
    model.label = label
    model.save!
  end
end
