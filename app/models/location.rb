# frozen_string_literal: true
# Monkeypatch clarat_base Location
require ClaratBase::Engine.root.join('app', 'models', 'location')

class Location < ActiveRecord::Base
  # Admin specific methods
  include PgSearch, ReformedValidationHack

  # Search
  pg_search_scope :search_everything,
                  against: [:id, :display_name],
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
    display += ", #{name}" unless name.blank?
    display += " | #{street}"
    display += ", #{addition}," unless addition.blank?
    self.display_name = display + " #{zip} #{city_name}"
  end
end
