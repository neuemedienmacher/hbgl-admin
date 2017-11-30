# frozen_string_literal: true

class Tag::Update < Tag::Create
  step Model(::Tag, :find_by), replace: 'model.build'
  step ::Lib::Macros::Live::SendChanges()
end
