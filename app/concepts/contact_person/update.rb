# frozen_string_literal: true

class ContactPerson::Update < ContactPerson::Create
  step Model(::ContactPerson, :find_by), replace: 'model.build'
  step ::Lib::Macros::Live::SendChanges()
end
