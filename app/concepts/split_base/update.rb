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
  step :generate_label # TODO: write tests for this!!
  step Contract::Persist()

  def generate_label(options, model:, **)
    contr = options['contract.default']
    label = "#{contr.title} (id: #{contr.id}"
    label += ", D: #{contr.divisions.map(&:label)}" if contr.divisions.any?
    label += ", SC: #{contr.solution_category.name})" if contr.solution_category
    model.label = label
  end
end
