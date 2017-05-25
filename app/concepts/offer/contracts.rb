# frozen_string_literal: true
module Offer::Contracts
  # rubocop:disable ClassLength
  class Create < Reform::Form
    # fill me!
    property :name
    property :description
    property :encounter
    property :expires_at
    property :code_word
    property :section_id
    property :slug
    property :age_from
    property :age_to
    property :organizations
    property :language_filters
    property :target_audience_filters
    property :area
    property :location
    property :aasm_state
    property :contact_people
    property :next_steps
    property :logic_version
    property :split_base_id
    property :starts_at
    property :categories
    property :section

    validates :name, presence: true
    # TODO: replace with complicated custom validation OR save stamp text in model
    # validates :name,
    #           uniqueness: { scope: :location_id },
    #           unless: ->(offer) { offer.location.nil? }
    validates :description, presence: true
    validates :encounter, presence: true
    validates :expires_at, presence: true
    validates :code_word, length: { maximum: 140 }
    validates :section_id, presence: true
    validates_uniqueness_of :slug, scope: :section_id

    MIN_AGE = 0
    MAX_AGE = 99
    # Age validation by section
    validates :age_from,
              numericality: { greater_than_or_equal_to: MIN_AGE,
                              only_integer: true,
                              less_than: MAX_AGE,
                              allow_blank: false },
              presence: true

    validates :age_to,
              numericality: { greater_than: MIN_AGE,
                              less_than_or_equal_to: MAX_AGE,
                              only_integer: true,
                              allow_blank: false },
              presence: true

    # Needs to be true before approval possible. Called in custom validation.
    # def before_approve
    #   TODO: Refactor age validations lead to simple HTML 5 checks which are
    #   eg not working in Safari. Also Rubocop complains...
    #   validate_associated_fields
    #   validate_target_audience
    # end
    validate :validate_associated_fields
    validate :only_visible_organizations
    validate :age_from_fits_age_to
    validate :location_and_area_fit_encounter
    validate :contact_people_are_choosable
    validate :no_more_than_10_next_steps
    validate :split_base_id_if_version_greater_7
    validate :start_date_must_be_before_expiry_date

    private

    # Uses method from CustomValidatable concern.
    def validate_associated_fields
      validate_associated_presence :organizations
      validate_associated_presence :language_filters
    end

    def validate_associated_presence field
      custom_error field, "needs_#{field}" if send(field).empty?
    end

    ## Custom Validation Methods ##

    # Age From has to be smaller than Age To
    def age_from_fits_age_to
      return if !age_from || !age_to || age_from.to_i <= age_to.to_i
      custom_error :age_from, 'age_from_be_smaller'
    end

    # Location is only allowed when encounter is personal, but if it is, it
    # HAS to be present. A remote offer needs an area.
    def location_and_area_fit_encounter
      if personal? && !location
        custom_error :location, 'needs_location_when_personal'
      elsif !personal?
        if location
          custom_error :location, 'refuses_location_when_remote'
        end
        unless area
          custom_error :area, 'needs_area_when_remote'
        end
      end
    end

    def custom_error attribute, string, optional = {}
      errors.add attribute, I18n.t(
        "offer.validations.#{string}"
      ), optional
    end

    # Fail if an organization added to this offer is not visible in frontend
    def only_visible_organizations
      # return unless association_instance_get(:organizations) # tests fail w/o
      if visible_in_frontend? && organizations.to_a.count { |orga| !orga.visible_in_frontend? }.positive?
        problematic_organization_names = invisible_orga_names
        custom_error :organizations, 'only_visible_organizations',
                     list: problematic_organization_names
      end
    end

    def invisible_orga_names
      (organizations - organizations.visible_in_frontend)
        .map(&:name).join(', ')
    end

    # Contact people either belong to one of the Organizations or are SPoC
    def contact_people_are_choosable
      contact_people.each do |contact_person|
        next if contact_person.spoc ||
                organizations.include?(contact_person.organization)
        # There are no intersections between both sets of orgas and not SPoC
        custom_error :contact_people, 'contact_person_not_choosable'
      end
    end

    def no_more_than_10_next_steps
      return if next_steps.to_a.size <= 10
      custom_error :next_steps, 'no_more_than_10_next_steps'
    end

    def split_base_id_if_version_greater_7
      return if !logic_version || logic_version.version < 7 || split_base_id
      errors.add :split_base, I18n.t('offer.validations.is_needed')
    end

    def start_date_must_be_before_expiry_date
      return if !starts_at || !expires_at || expires_at > starts_at
      custom_error :starts_at, 'must_be_smaller_than_expiry_date'
    end

    def personal?
      encounter == 'personal'
    end

    VISIBLE_FRONTEND_STATES = %w(approved expired).freeze

    def visible_in_frontend?
      VISIBLE_FRONTEND_STATES.include?(aasm_state)
    end
  end
  # rubocop:enable ClassLength
  class Update < Create
    # fill me!
    validate :sections_must_match_categories_sections
    validate :at_least_one_section_of_each_category_must_be_present
    validate :location_fits_organization
    validate :validate_target_audience_filters

    # Ensure selected organization is the same as the selected location's
    # organization
    def location_fits_organization
      ids = organizations.pluck(:id)
      if personal? && location && !ids.include?(location.organization_id)
        errors.add :location_id, I18n.t(
          'offer.validations.location_fits_organization.location_error'
        )
        errors.add :organizations, I18n.t(
          'offer.validations.location_fits_organization.organization_error'
        )
      end
    end

    # The offers sections must match the categories sections
    def sections_must_match_categories_sections
      if categories.any?
        categories.each do |category|
          next if category.sections.include?(section)
          errors.add(:categories, I18n.t('offer.validations.category_for_section_needed',
                                         world: section.name))
        end
      end
    end

    def at_least_one_section_of_each_category_must_be_present
      if categories.any?
        categories.each do |offer_category|
          next if offer_category.sections.include?(section)
          errors.add(:categories, I18n.t('offer.validations.section_for_category_needed',
                                         category: offer_category.name))
        end
      end
    end

    def validate_target_audience_filters
      unless target_audience_filters.any?
        errors.add(
          :target_audience_filters,
          I18n.t('offer.validations.needs_target_audience_filters')
        )
      end
    end
  end

  class ChangeState < Update
    # replace this with something useful
    delegate :valid?, to: :model, prefix: false
    delegate :errors, to: :model, prefix: false
  end
end
