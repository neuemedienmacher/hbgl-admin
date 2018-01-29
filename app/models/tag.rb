# frozen_string_literal: true

# Monkeypatch clarat_base tag
require ClaratBase::Engine.root.join('app', 'models', 'tag')

class Tag < ApplicationRecord
  include ReformedValidationHack

  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[id name_de name_en],
                  using: { tsearch: { prefix: true } }
end
