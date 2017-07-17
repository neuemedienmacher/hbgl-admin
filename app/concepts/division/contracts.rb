# frozen_string_literal: true
module Division::Contracts
  class Create < Reform::Form
    property :name
    property :organization
    property :websites
    property :section
    property :city
    property :area
    property :presumed_categories
    property :presumed_solution_categories
    property :comment
    property :size

    validates :name, presence: true
    validate ::Lib::Validators::UnnestedPresence :organization
    validates :section, presence: true
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

  class Update < Create
    property :id, writeable: false
    # update-specific validations?
  end
end
