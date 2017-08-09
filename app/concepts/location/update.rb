# frozen_string_literal: true
class Location::Update < Location::Create
  step Model(::Location, :find_by), replace: 'model.build'
end
