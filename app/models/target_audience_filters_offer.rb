# frozen_string_literal: true
# Monkeypatch clarat_base FiltersOffer
# NOTE only required for old backend - do this differently in new backend!
require ClaratBase::Engine.root.join('app', 'models', 'target_audience_filters_offer')

class TargetAudienceFiltersOffer < ActiveRecord::Base
  # Enumerization
  extend Enumerize

  enumerize :gender_first_part_of_stamp, in: STAMP_FIRST_PART_GENDERS
  enumerize :gender_second_part_of_stamp, in: STAMP_SECOND_PART_GENDERS
  enumerize :residency_status, in: RESIDENCY_STATUSES

  # Validations
  validate :age_from_fits_age_to
  validate :age_from_within_bounds
  validate :age_to_within_bounds
  validates :addition, length: { maximum: 80 }
  validates :offer_id, presence: true
  validates :target_audience_filter_id, presence: true
  validates :offer_id, uniqueness: {
    scope: [:target_audience_filter_id, :residency_status]
  }
  validates :target_audience_filter_id, uniqueness: {
    scope: [:offer_id, :residency_status]
  }
  validates :residency_status, uniqueness: {
    scope: [:offer_id, :target_audience_filter_id]
  }

  ## Custom Validation Methods ##
  # Age From has to be smaller than Age To (if both exist)
  def age_from_fits_age_to
    return if !age_from || !age_to || age_from <= age_to
    errors.add :age_from, I18n.t('offer.validations.age_from_be_smaller')
  end

  def age_from_within_bounds
    return if !age_from || age_from >= MIN_AGE && age_from <= MAX_AGE
    errors.add :age_from, I18n.t('offer.validations.age_not_within_bounds')
  end

  def age_to_within_bounds
    return if !age_to || age_to >= MIN_AGE && age_to <= MAX_AGE
    errors.add :age_to, I18n.t('offer.validations.age_not_within_bounds')
  end

  # Callbacks
  before_save :generate_stamps!

  require_relative '../objects/value/target_audience_filters_offer_stamp.rb'
  def generate_stamps!
    I18n.available_locales.each do |locale|
      self.send(
        "stamp_#{locale}=",
        TargetAudienceFiltersOfferStamp.generate_stamp(
          self, offer.section.identifier, locale
        )
      )
    end
  end

  # For rails_admin display
  def name
    if stamp_de.blank? == false
      stamp_de
    elsif target_audience_filter && offer
      "#{target_audience_filter.name} (Offer##{offer.id})"
    else
      'Leere Verknüpfung'
    end
  end
end
