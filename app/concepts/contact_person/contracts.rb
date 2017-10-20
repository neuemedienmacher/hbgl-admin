# frozen_string_literal: true

module ContactPerson::Contracts
  class Create < Reform::Form
    property :first_name
    property :last_name
    property :operational_name
    property :academic_title
    property :gender
    property :responsibility
    property :position
    property :spoc
    property :area_code_1
    property :local_number_1
    property :area_code_2
    property :local_number_2
    property :fax_area_code
    property :fax_number
    # property :street
    # property :zip_and_city
    property :email
    property :organization

    validate ::Lib::Validators::UnnestedPresence :organization
    validates :area_code_1, format: /\A\d*\z/, length: { maximum: 6 }
    validates :local_number_1, format: /\A\d*\z/, length: { maximum: 32 }
    validates :area_code_2, format: /\A\d*\z/, length: { maximum: 6 }
    validates :local_number_2, format: /\A\d*\z/, length: { maximum: 32 }
    validates :fax_area_code, format: /\A\d*\z/, length: { maximum: 6 }
    validates :fax_number, format: /\A\d*\z/, length: { maximum: 32 }

    validate :at_least_one_field_present
    def at_least_one_field_present
      all_blank = %w[first_name last_name operational_name local_number_1
                     fax_number email].all? do |field|
        self.send(field).blank?
      end

      if all_blank
        errors.add :base, I18n.t('contact_person.validations.incomplete')
      end
    end
  end
end
