# frozen_string_literal: true

# Monkeypatch clarat_base NextStep
require ClaratBase::Engine.root.join('app', 'models', 'next_step')

class NextStep < ApplicationRecord
  include ReformedValidationHack

  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[id text_de],
                  using: { tsearch: { prefix: true, normalization: 2 } }
end
