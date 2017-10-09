# frozen_string_literal: true

# Monkeypatch clarat_base Location
require ClaratBase::Engine.root.join('app', 'models', 'location')

class Location < ApplicationRecord
  # Admin specific methods
  include ReformedValidationHack
  include PgSearch

  # Search
  pg_search_scope :search_pg,
                  against: %i[id display_name],
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

  before_hack :generate_display_name_for_rails_admin_too
  def generate_display_name_for_rails_admin_too
    display = organization_name.to_s
    display += ", #{name}" if name.present?
    display += " | #{street}"
    display += ", #{addition}," if addition.present?
    self.display_name = display + " #{zip} #{city_name}"
  end

  # TODO: move callsbacks to operations!
  # Callbacks
  after_commit :after_commit

  def after_commit
    # queue geocoding

    if self.previous_changes.key?(:street) || self.previous_changes.key?(:zip) ||
       self.previous_changes.key?(:city_id) ||
       self.previous_changes.key?(:federal_state_id)
      GeocodingWorker.perform_async self.id
    end

    # update algolia indices of offers (for location_visible) if changed
    if self.previous_changes.key?(:visible)
      self.offers.visible_in_frontend.find_each(&:index!)
    end
  end
end
