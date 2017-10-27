# frozen_string_literal: true

# Monkeypatch clarat_base Location
require ClaratBase::Engine.root.join('app', 'models', 'location')

class Location < ApplicationRecord
  # Admin specific methods
  include PgSearch

  # Search
  pg_search_scope :search_pg,
                  against: %i[id label],
                  using: { tsearch: { prefix: true } }

  # Customize duplication.
  def partial_dup
    self.dup.tap do |location|
      location.hq = false
      location.offers = []
      location.organization = self.organization
      location.federal_state = self.federal_state
      location.city = self.city
    end
  end
end
