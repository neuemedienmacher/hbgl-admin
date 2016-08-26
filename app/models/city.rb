# frozen_string_literal: true
# Monkeypatch clarat_base City
require ClaratBase::Engine.root.join('app', 'models', 'city')

class City < ActiveRecord::Base
  # Load thresholds from env-variables or use 1 for testing
  OFFER_THRESHOLD = Integer(ENV['THRESHOLDS_OFFER_COUNT'] || 1)
  ORGANIZATION_THRESHOLD = Integer(ENV['THRESHOLDS_ORGA_COUNT'] || 1)

  # Admin specific methods
  def thresholds_reached?
    offers.approved.count >= OFFER_THRESHOLD &&
      organizations.approved.count >= ORGANIZATION_THRESHOLD
  end
end
