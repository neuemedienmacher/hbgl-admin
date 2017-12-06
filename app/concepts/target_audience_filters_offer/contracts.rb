# frozen_string_literal: true

require 'reform/form/coercion'

module TargetAudienceFiltersOffer::Contracts
  class Create < Reform::Form
    feature Coercion

    property :target_audience_filter
    property :offer
    property :residency_status
    property :gender_first_part_of_stamp
    property :gender_second_part_of_stamp
    property :age_from, type: Types::Form::Int
    property :age_to, type: Types::Form::Int
    property :age_visible

    validate ::Lib::Validators::UnnestedPresence :offer
    validates :target_audience_filter, presence: true
    validates :age_from, presence: true
    validates :age_to, presence: true

    validate :age_from_within_bounds
    validate :age_to_within_bounds
    validate :age_from_fits_age_to
    validate :min_age_for_parents

    ## Custom Validation Methods ##
    # Age From has to be smaller than Age To (if both exist)
    def age_from_fits_age_to
      return if age_from && age_to && age_from <= age_to
      errors.add :age_from, I18n.t('offer.validations.age_from_be_smaller')
    end

    def age_from_within_bounds
      return if age_from && age_from >= min_age && age_from <= max_age
      errors.add :age_from, I18n.t('offer.validations.age_not_within_bounds')
    end

    def age_to_within_bounds
      return if age_to && age_to >= min_age && age_to <= max_age
      errors.add :age_to, I18n.t('offer.validations.age_not_within_bounds')
    end

    def min_age_for_parents
      return if age_visible == false || age_from > 11 ||
                !(TargetAudienceFilter.find(
                  target_audience_filter[:id]
                ).identifier.include? 'parents')
      errors.add :age_from, I18n.t('offer.validations.parent_from_age_too_low')
    end

    private

    def min_age
      ::TargetAudienceFiltersOffer::MIN_AGE
    end

    def max_age
      ::TargetAudienceFiltersOffer::MAX_AGE
    end
  end
end
