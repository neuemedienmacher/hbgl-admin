# frozen_string_literal: true
# This represents the entire stamp-generation and should stay together
# rubocop:disable Metrics/ClassLength, Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
class TargetAudienceFiltersOfferStamp
  def self.generate_stamp filters_offer, section, locale
    # generate stamp
    generate_filters_offer_stamp(
      section, filters_offer, filters_offer.target_audience_filter.identifier, locale
    )
  end

  private_class_method

  def self.generate_filters_offer_stamp section, filters_offer, ta, locale
    locale_entry = 'offer.stamp.target_audience.' + ta.to_s

    if %w(family_children family_parents family_nuclear_family refugees_general
          family_parents_to_be refugees_children refugees_parents_to_be
          refugees_umf refugees_parents refugees_families ).include?(ta)
      locale_entry += send("stamp_#{ta}", filters_offer)
    end
    # build separate parts of stamp and join them with locale-specific format
    stamp = I18n.t(locale_entry, locale: locale)
    opt_age = stamp_optional_age(filters_offer, ta, section, locale)
    opt_status = stamp_optional_residency_status(filters_offer, locale, section)
    generate_final_stamp(locale, stamp, opt_age, opt_status)
  end

  def self.generate_final_stamp locale, stamp, opt_age, opt_status
    I18n.t('offer.stamp.format', locale: locale,
                                 stamp: stamp,
                                 optional_age: opt_age,
                                 optional_status: opt_status)
  end

  # --------- FAMILY

  def self.stamp_family_children f_o
    if !f_o.gender_first_part_of_stamp.nil?
      ".#{f_o.gender_first_part_of_stamp}"
    elsif f_o.age_from && f_o.age_to && f_o.age_from >= 14 && f_o.age_to >= 14
      '.adolescents'
    elsif f_o.age_from && f_o.age_to && f_o.age_from < 14 && f_o.age_to >= 14
      '.and_adolescents'
    else
      '.default'
    end
  end

  def self.stamp_family_parents filters_offer
    gender_string_builder filters_offer
  end

  def self.stamp_family_nuclear_family f_o
    if f_o.gender_first_part_of_stamp.nil? &&
       (f_o.gender_second_part_of_stamp.nil? ||
         stamp_family_nuclear_family_default_special(f_o)
       )
      '.default'
    else
      locale_entry =
        if f_o.gender_first_part_of_stamp.nil?
          '.neutral'
        else
          '.' + f_o.gender_first_part_of_stamp
        end
      locale_entry + stamp_family_nuclear_family_gender_second_part(f_o)
    end
  end

  # (...)
  def self.stamp_family_nuclear_family_default_special f_o
    f_o.gender_second_part_of_stamp == 'neutral' &&
      !f_o.age_visible && f_o.age_to && f_o.age_to > 1
  end

  def self.stamp_family_nuclear_family_gender_second_part f_o
    if f_o.gender_second_part_of_stamp == 'neutral' &&
       f_o.age_from && f_o.age_to && f_o.age_from.zero? && f_o.age_to == 1
      '.with_baby'
    elsif f_o.gender_second_part_of_stamp.nil?
      '.neutral'
    else
      '.' + f_o.gender_second_part_of_stamp
    end
  end

  def self.stamp_family_parents_to_be filters_offer
    if filters_offer.gender_first_part_of_stamp.nil? &&
       filters_offer.gender_second_part_of_stamp.nil?
      '.default'
    else
      locale_entry =
        if filters_offer.gender_first_part_of_stamp.nil?
          '.neutral'
        else
          '.' + filters_offer.gender_first_part_of_stamp
        end
      locale_entry +
        if filters_offer.gender_second_part_of_stamp.nil?
          '.default'
        else
          '.' + filters_offer.gender_second_part_of_stamp
        end
    end
  end

  def self.gender_string_builder filters_offer
    locale_entry =
      if filters_offer.gender_first_part_of_stamp.nil?
        '.neutral'
      else
        '.' + filters_offer.gender_first_part_of_stamp
      end
    locale_entry +
      if filters_offer.gender_second_part_of_stamp.nil?
        '.neutral'
      else
        '.' + filters_offer.gender_second_part_of_stamp
      end
  end

  # --------- REFUGEES

  def self.stamp_refugees_children f_o
    if !f_o.gender_first_part_of_stamp.nil?
      ".#{f_o.gender_first_part_of_stamp}"
    elsif f_o.age_from && f_o.age_to && f_o.age_from >= 14 && f_o.age_to >= 14
      '.adolescents'
    elsif f_o.age_from && f_o.age_to && f_o.age_from < 14 && f_o.age_to >= 14
      '.and_adolescents'
    else
      '.default'
    end
  end

  def self.stamp_refugees_umf filters_offer
    if filters_offer.gender_first_part_of_stamp.nil?
      '.neutral'
    else
      '.' + filters_offer.gender_first_part_of_stamp
    end
  end

  # follows the same logic as self.stamp_refugees_umf
  def self.stamp_refugees_parents_to_be filters_offer
    stamp_refugees_umf(filters_offer)
  end

  def self.stamp_refugees_parents filters_offer
    gender_string_builder filters_offer
  end

  def self.stamp_refugees_families f_o
    if f_o.gender_first_part_of_stamp.nil? &&
       f_o.gender_second_part_of_stamp.nil?
      '.default'
    else
      locale_entry =
        if f_o.gender_first_part_of_stamp.nil?
          '.neutral'
        else
          '.' + f_o.gender_first_part_of_stamp
        end
      locale_entry + stamp_family_nuclear_family_gender_second_part(f_o)
    end
  end

  def self.stamp_refugees_general f_o
    locale_entry =
      if f_o.gender_first_part_of_stamp.nil?
        '.neutral'
      else
        '.' + f_o.gender_first_part_of_stamp
      end
    if f_o.gender_first_part_of_stamp == 'male' ||
       f_o.gender_first_part_of_stamp == 'female'
      locale_entry += f_o.age_from && f_o.age_from >= 18 ? '.default' : '.special'
    end
    locale_entry + stamp_refugees_general_adult_special(f_o)
  end

  def self.stamp_refugees_general_adult_special f_o
    if f_o.gender_first_part_of_stamp.blank? ||
       f_o.gender_first_part_of_stamp == 'neutral'
      if f_o.age_to && f_o.age_from && f_o.age_to >= 18 && f_o.age_from >= 18
        '.adults'
      else
        '.neutral'
      end
    else
      ''
    end
  end

  def self.stamp_optional_residency_status filters_offer, locale, section
    if section == 'refugees' && filters_offer.residency_status.blank? == false
      locale_entry = "offer.stamp.status.#{filters_offer.residency_status}"
      " #{I18n.t(locale_entry, locale: locale)}"
    else
      ''
    end
  end

  # --------- GENERAL (AGE)

  def self.stamp_optional_age filters_offer, ta, section, locale
    append_age =
      filters_offer.age_visible && stamp_append_age?(filters_offer, ta)
    child_age = stamp_child_age? filters_offer, ta

    if append_age
      age_string = generate_age_for_stamp(
        filters_offer.age_from,
        filters_offer.age_to,
        section,
        locale
      )
      locale_age_string =
        I18n.t('offer.stamp.age.age_of_child', locale: locale, age: age_string)
      " (#{child_age ? locale_age_string : age_string})"
    else
      ''
    end
  end

  def self.stamp_append_age? filters_offer, ta
    ta != 'family_everyone' &&
      !(ta == 'family_nuclear_family' &&
        filters_offer.gender_first_part_of_stamp.nil? &&
        filters_offer.gender_second_part_of_stamp.nil?)
  end

  def self.stamp_child_age? filters_offer, ta
    %w(family_parents family_relatives refugees_parents).include?(ta) &&
      !filters_offer.gender_second_part_of_stamp.nil? &&
      filters_offer.gender_second_part_of_stamp == 'neutral'
  end

  def self.generate_age_for_stamp from, to, section, locale
    if from && from.zero?
      I18n.t('offer.stamp.age.age_to', locale: locale, count: to)
    elsif to && (to == 99 || section == 'family' && to > 17)
      I18n.t('offer.stamp.age.age_from', locale: locale, count: from)
    elsif from && to && from == to
      "#{from} #{I18n.t('offer.stamp.age.suffix', locale: locale)}"
    else
      "#{from} – #{to} #{I18n.t('offer.stamp.age.suffix', locale: locale)}"
    end
  end
end
# rubocop:enable Metrics/ClassLength, Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
