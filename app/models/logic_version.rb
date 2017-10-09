# frozen_string_literal: true

# Monkeypatch clarat_base Location
require ClaratBase::Engine.root.join('app', 'models', 'logic_version')
# Version of business-internal entry logic
class LogicVersion < ApplicationRecord
  include ReformedValidationHack

  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[version name description],
                  using: { tsearch: { prefix: true } }
end
