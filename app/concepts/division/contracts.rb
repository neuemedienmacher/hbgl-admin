# frozen_string_literal: true

module Division::Contracts
  class Base < Reform::Form
    property :addition
    property :organization
    property :websites
    property :city
    property :area
    property :presumed_tags
    property :presumed_solution_categories
    property :comment
    property :size

    validate ::Lib::Validators::UnnestedPresence :organization
    validate :city_or_area_must_be_present

    private

    def city_or_area_must_be_present
      if !city && !area
        errors.add :city, 'Stadt oder Area muss ausgewählt sein'
        errors.add :area, 'Stadt oder Area muss ausgewählt sein'
        false
      else
        true
      end
    end
  end

  class Create < Base
    property :section

    validates :section, presence: true
  end

  class Update < Base
    property :id, writeable: false
    # update-specific validations?
  end
end
