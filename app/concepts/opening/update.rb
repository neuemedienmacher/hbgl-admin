# frozen_string_literal: true

class Opening::Update < Opening::Create
  step Model(::Opening, :find_by), replace: 'model.build'
  step ::Lib::Macros::Live::SendChanges()
end
