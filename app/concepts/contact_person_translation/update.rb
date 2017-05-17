# frozen_string_literal: true
class ContactPersonTranslation::Update < Trailblazer::Operation
  step Model(::ContactPersonTranslation, :find_by)

  step Contract::Build()
  step Contract::Validate()
  step Contract::Persist()

  extend Contract::DSL
  contract do
    property :responsibility
    property :source
  end
end
