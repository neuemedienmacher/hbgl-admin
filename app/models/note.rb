# frozen_string_literal: true

# Monkeypatch clarat_base NextStep
require ClaratBase::Engine.root.join('app', 'models', 'note')
# Comment for internal use by admins.
# Allows adding note to any other Model. Displayed in Admin backend.
class Note < ApplicationRecord
  # Concerns
  include NoteReferencable # A note can be the target of references

  include ReformedValidationHack
end
