# frozen_string_literal: true

# Monkeypatch clarat_base Definition
require ClaratBase::Engine.root.join('app', 'models', 'definition')
class Definition < ApplicationRecord
  include ReformedValidationHack

  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[id key explanation],
                  using: { tsearch: { prefix: true } }
end
