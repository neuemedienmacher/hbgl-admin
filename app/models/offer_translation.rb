# frozen_string_literal: true

# Monkeypatch clarat_base OfferTranslation
require ClaratBase::Engine.root.join('app', 'models', 'offer_translation')

class OfferTranslation < ApplicationRecord
  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[
                    id offer_id name locale source
                  ],
                  using: { tsearch: { prefix: true } }
end
