# frozen_string_literal: true
# Monkeypatch clarat_base Definition
require ClaratBase::Engine.root.join('app', 'models', 'definition')
class Definition < ActiveRecord::Base
  include ReformedValidationHack

  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: [:id, :key, :explanation],
                  using: { tsearch: { prefix: true } }
end
