# frozen_string_literal: true
module Organization::Contracts
  class Create < Reform::Form
    property :name
    property :priority
    property :website
    property :comment
    property :divisions
    property :locations
    property :contact_people

    validates :name, length: { maximum: 100 }, presence: true
    validates_uniqueness_of :name
    validates :website, presence: true

    include ::NestedValidation
    validate_nested :website, Website::Contracts::Create
    validate_nested_collection :divisions, Division::Contracts::Create
    validate_nested_collection :locations, Location::Contracts::Create
    validate_nested_collection :contact_people, ContactPerson::Contracts::Create

    # TODO: ausschliesslich own erlauben in Auswahl und nested create
    # validate :validate_websites_hosts
    # def validate_websites_hosts
    #   websites.where.not(host: 'own').each do |website|
    #     errors.add(
    #       :base,
    #       I18n.t('organization.validations.website_host', website: website.url)
    #     )
    #   end
    # end
  end

  class Update < Create
    property :id, writeable: false
    property :description
    property :legal_form
    property :charitable
    property :umbrella_filter_ids
    property :mailings
  end

  # validates :slug, uniqueness: true
  # validates :mailings, presence: true

  class ChangeState < Update
    validates :description, presence: true
    validates :legal_form, presence: true

    validate :one_hq_location?
    def one_hq_location?
      if locations.where(hq: true).count != 1
        errors.add(:base, I18n.t('organization.validations.hq_location'))
      end
    end
  end
end
