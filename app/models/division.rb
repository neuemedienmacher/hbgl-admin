# frozen_string_literal: true

# Monkeypatch clarat_base Division
require ClaratBase::Engine.root.join('app', 'models', 'division')

class Division < ApplicationRecord
  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[id addition size label],
                  using: { tsearch: { prefix: true } }
end
