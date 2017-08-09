# frozen_string_literal: true
class City::Create < Trailblazer::Operation
  step Model(::City, :new)
  step Policy::Pundit(CityPolicy, :create?)

  step Contract::Build(constant: City::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()
end
