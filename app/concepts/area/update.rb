# frozen_string_literal: true

class Area::Update < Area::Create
  step Model(::Area, :find_by), replace: 'model.build'
  step ::Lib::Macros::Live::SendChanges()
end
