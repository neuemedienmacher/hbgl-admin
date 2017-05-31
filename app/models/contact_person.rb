# frozen_string_literal: true
# Monkeypatch clarat_base CotactPerson
require ClaratBase::Engine.root.join('app', 'models', 'contact_person')

class ContactPerson < ActiveRecord::Base
  # Search
  include PgSearch
  pg_search_scope :search_everything,
                  against: [
                    :id, :position, :operational_name, :first_name, :last_name
                  ],
                  using: { tsearch: { prefix: true } }

  # Admin specific methods

  include Translations, ReformedValidationHack, PgSearch

  # Search
  pg_search_scope :search_everything,
                  against: [:id, :display_name],
                  using: { tsearch: { prefix: true } }

  # Customize duplication.
  def partial_dup
    self.dup.tap do |contact_person|
      contact_person.offers = self.offers
    end
  end

  # For rails_admin display
  def display_name
    if first_name.blank? && last_name.blank?
      "#{position_display_name}##{id} #{operational_name} (#{organization_name})"
    else
      "#{position_display_name}##{id} #{first_name} #{last_name} "\
      "(#{organization_name})".squeeze(' ')
    end
  end

  def position_display_name
    if position && !position.empty?
      I18n.t("enumerize.contact_person.position.#{position}") + ': '
    else
      ''
    end
  end
end
