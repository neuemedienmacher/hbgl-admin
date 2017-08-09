# frozen_string_literal: true
# Monkeypatch clarat_base Division
require ClaratBase::Engine.root.join('app', 'models', 'division')

class Division < ActiveRecord::Base
  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: [:id, :addition, :size],
                  using: { tsearch: { prefix: true } }

  # Methods
  def display_name
    display_name = "#{organization&.name} (#{section.identifier})"
    display_name += ", City: #{city.name}" if city
    display_name += ", Area: #{area.name}" if area
    display_name += ", Addition: #{addition}" unless addition.blank?
    display_name
  end
end
