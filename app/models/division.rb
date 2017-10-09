# frozen_string_literal: true

# Monkeypatch clarat_base Division
require ClaratBase::Engine.root.join('app', 'models', 'division')

class Division < ApplicationRecord
  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[id addition size],
                  using: { tsearch: { prefix: true } }

  # Methods
  def display_name
    display_name = "#{organization&.name} (#{section.identifier})"
    display_name += ", City: #{city.name}" if city
    display_name += ", Area: #{area.name}" if area
    display_name += ", Addition: #{addition}" if addition.present?
    display_name
  end
end
