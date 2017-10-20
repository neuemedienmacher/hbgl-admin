# frozen_string_literal: true

# Monkeypatch clarat_base CotactPerson
require ClaratBase::Engine.root.join('app', 'models', 'contact_person')

class ContactPerson < ApplicationRecord
  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[
                    id position operational_name first_name last_name
                  ],
                  using: { tsearch: { prefix: true } }

  # pg_search_scope :search_pg_index,
  #                 against: [
  #                   :id, :position, :operational_name, :first_name, :last_name
  #                 ],
  #                 associated_against: { organization: :name },
  #                 using: { tsearch: { prefix: true } }

  # Admin specific methods

  include ReformedValidationHack
  include Translations

  # Customize duplication.
  def partial_dup
    self.dup.tap do |contact_person|
      contact_person.offers = self.offers
    end
  end

  # For rails_admin display
  def label
    if first_name.blank? && last_name.blank?
      "#{position_label}##{id} #{operational_name} (#{organization_name})"
    else
      "#{position_label}##{id} #{first_name} #{last_name} "\
      "(#{organization_name})".squeeze(' ')
    end
  end

  def position_label
    if position.present?
      I18n.t("enumerize.contact_person.position.#{position}") + ': '
    else
      ''
    end
  end

  # TODO: move callsbacks to operations!
  # Callbacks
  after_create :after_create
  after_commit :after_commit

  def after_create
    self.generate_translations!
  end

  def after_commit
    fields = self.changed_translatable_fields
    return true if fields.empty?
    self.generate_translations! fields
  end
end
