# frozen_string_literal: true
# Monkeypatch clarat_base Location
require ClaratBase::Engine.root.join('app', 'models', 'federal_state')
# Normalization of (German) federal states.
class FederalState < ActiveRecord::Base
  include ReformedValidationHack, PgSearch

  # Search
  pg_search_scope :search_everything,
                  against: [:id, :name],
                  using: { tsearch: { prefix: true } }
end
