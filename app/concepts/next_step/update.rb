# frozen_string_literal: true

class NextStep::Update < NextStep::Create
  step Model(::NextStep, :find_by), replace: 'model.build'
  step ::Lib::Macros::Live::SendChanges()
end
