# frozen_string_literal: true

# Monkeypatch clarat_base Offer
require ClaratBase::Engine.root.join('app', 'models', 'opening')
# Opening Times of Offers
class Opening < ApplicationRecord
  include ReformedValidationHack

  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[id name],
                  using: { tsearch: { prefix: true } }
end
