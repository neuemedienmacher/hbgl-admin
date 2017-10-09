# frozen_string_literal: true

module Offer::Contracts
  class Create < Reform::Form
    # fill me!
    property :name
    property :description
    property :comment
    property :encounter
    property :section
    property :slug
    property :language_filters
    property :target_audience_filters_offers
    property :trait_filters
    property :area
    property :location
    property :aasm_state
    property :contact_people
    property :next_steps
    property :logic_version
    property :split_base
    property :starts_at
    property :ends_at
    property :categories
    property :section
    property :tags
    property :openings
    property :opening_specification
    property :websites
    property :hide_contact_people

    validates :name, presence: true
    # TODO: replace with complicated custom validation OR save stamp text in model
    # validates :name,
    #           uniqueness: { scope: :location },
    #           unless: ->(offer) { offer.location.nil? }
    validates :description, presence: true
    validates :encounter, presence: true
    validates :section, presence: true

    # Needs to be true before approval possible. Called in custom validation.
    # def before_approve
    #   TODO: Refactor age validations lead to simple HTML 5 checks which are
    #   eg not working in Safari. Also Rubocop complains...
    #   validate_associated_fields
    #   validate_target_audience
    # end
    validate :validate_associated_fields
    # validate :only_visible_organizations
    validate :location_and_area_fit_encounter
    validate :contact_people_are_choosable
    validate :no_more_than_10_next_steps
    validate :split_base_if_version_greater_7

    # association getter
    def organizations
      split_base&.organizations || []
    end

    private

    # Uses method from CustomValidatable concern.
    def validate_associated_fields
      # validate_associated_presence :organizations
      validate_associated_presence :language_filters
    end

    def validate_associated_presence field
      custom_error field, "needs_#{field}" if send(field).empty?
    end

    ## Custom Validation Methods ##

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

    # NOTE: taking this out because organizations are no longer directly associated
    # # Fail if an organization added to this offer is not visible in frontend
    # def only_visible_organizations
    #   # return unless association_instance_get(:organizations) # tests fail w/o
    #   if visible_in_frontend? && organizations.to_a.count { |orga| !orga.visible_in_frontend? }.positive?
    #     problematic_organization_names = invisible_orga_names
    #     custom_error :organizations, 'only_visible_organizations',
    #                  list: problematic_organization_names
    #   end
    # end
    #
    # def invisible_orga_names
    #   (organizations - organizations.visible_in_frontend)
    #     .map(&:name).join(', ')
    # end

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

    def split_base_if_version_greater_7
      return if !logic_version || logic_version.version < 7 || split_base
      errors.add :split_base, I18n.t('offer.validations.is_needed')
    end

    def personal?
      encounter == 'personal'
    end

    # VISIBLE_FRONTEND_STATES = %w(approved expired).freeze
    #
    # def visible_in_frontend?
    #   VISIBLE_FRONTEND_STATES.include?(aasm_state)
    # end
  end

  class Update < Create
    property :id, virtual: true

    # fill me!
    validate :sections_must_match_categories_sections
    validate :at_least_one_section_of_each_category_must_be_present
    validate :location_fits_organization
    validates :target_audience_filters_offers, presence: true
    # validate :validate_target_audience_filters_offers

    # Ensure selected organization is the same as the selected location's
    # organization
    def location_fits_organization
      ids = organizations.pluck(:id)
      if personal? && location && location.organization &&
         !ids.include?(location.organization.id)
        errors.add :location, I18n.t(
          'offer.validations.location_fits_organization'
        )
      end
    end

    # The offers sections must match the categories sections
    def sections_must_match_categories_sections
      if categories.any?
        categories.each do |category|
          next if category.reload.sections.include?(section)
          errors.add(:categories,
                     I18n.t('offer.validations.category_for_section_needed',
                            world: section.name))
        end
      end
    end

    def at_least_one_section_of_each_category_must_be_present
      if categories.any?
        categories.each do |offer_category|
          next if offer_category.reload.sections.include?(section)
          errors.add(:categories,
                     I18n.t('offer.validations.section_for_category_needed',
                            category: offer_category.name))
        end
      end
    end
    #
    # def validate_target_audience_filters_offers
    #   unless target_audience_filters_offers.any?
    #     errors.add(
    #       :target_audience_filters_offers,
    #       I18n.t('offer.validations.needs_target_audience_filters')
    #     )
    #   end
    # end
  end

  class ChangeState < Update # rails admin hack only
    # replace this with something useful
    delegate :valid?, to: :model, prefix: false
    delegate :errors, to: :model, prefix: false
  end
end
