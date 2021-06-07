class City::Update < Trailblazer::Operation
  step Model(::City, :find_by)
  step Policy::Pundit(PermissivePolicy, :update?)

  step Contract::Build(constant: City::Contracts::Update)
  step Contract::Validate()
  step Contract::Persist()
  step ::Lib::Macros::Live::SendChanges()
end
