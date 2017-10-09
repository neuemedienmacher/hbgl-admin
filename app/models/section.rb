# frozen_string_literal: true

# Monkeypatch clarat_base Section
require ClaratBase::Engine.root.join('app', 'models', 'section')

class Section < ApplicationRecord
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[id name identifier],
                  using: { tsearch: { prefix: true } }
end
