# frozen_string_literal: true
class Website::Create < Trailblazer::Operation
  step Model(::Website, :new)
  step Policy::Pundit(WebsitePolicy, :create?)

  step Contract::Build(constant: Website::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()
end
