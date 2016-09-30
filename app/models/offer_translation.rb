# frozen_string_literal: true
# Monkeypatch clarat_base OfferTranslation
require ClaratBase::Engine.root.join('app', 'models', 'offer_translation')

class OfferTranslation < ActiveRecord::Base
  # Search
  include PgSearch
  # Search
  pg_search_scope :search_everything,
                  against: [
                    :id, :offer_id, :name, :locale, :source
                  ],
                  using: { tsearch: { prefix: true } }
end
