# frozen_string_literal: true
# Monkeypatch clarat_base City
require ClaratBase::Engine.root.join('app', 'models', 'city')

class City < ActiveRecord::Base
  OFFER_THRESHOLD = 150
  ORGANIZATION_THRESHOLD = 30
  # Admin specific methods

  def thresholds_reached?
    offers.approved.count >= OFFER_THRESHOLD &&
      organizations.approved.count >= ORGANIZATION_THRESHOLD # TODO: Test this!!
  end
end
