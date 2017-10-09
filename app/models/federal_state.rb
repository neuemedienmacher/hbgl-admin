# frozen_string_literal: true

# Monkeypatch clarat_base Location
require ClaratBase::Engine.root.join('app', 'models', 'federal_state')
# Normalization of (German) federal states.
class FederalState < ApplicationRecord
  include PgSearch
  include ReformedValidationHack

  # Search
  pg_search_scope :search_pg,
                  against: %i[id name],
                  using: { tsearch: { prefix: true } }
end
