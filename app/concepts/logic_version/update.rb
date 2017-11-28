# frozen_string_literal: true

class LogicVersion::Update < LogicVersion::Create
  step Model(::LogicVersion, :find_by), replace: 'model.build'
  step ::Lib::Macros::Live::SendChanges()
end
