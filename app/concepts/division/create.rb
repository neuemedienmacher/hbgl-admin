# frozen_string_literal: true
class Division::Create < Trailblazer::Operation
  step Model(::Division, :new)

  step Contract::Build()
  step Contract::Validate()
  step Contract::Persist()

  # include Trailblazer::Operation::Policy
  # policy ::DivisionPolicy, :create?

  extend Contract::DSL
  contract do
    property :name
    property :description
    property :organization_id
    property :section_filter_id

    validates :name, presence: true
    validates :organization_id, presence: true
    validates :section_filter_id, presence: true
  end
end
