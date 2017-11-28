# frozen_string_literal: true

# Monkeypatch clarat_base SearchLocation
require ClaratBase::Engine.root.join('app', 'models', 'search_location')

class SearchLocation < ApplicationRecord
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[id query latitude longitude],
                  using: { tsearch: { prefix: true } }
end
