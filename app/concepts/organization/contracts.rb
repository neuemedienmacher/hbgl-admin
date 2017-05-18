# frozen_string_literal: true
module Organization::Contracts
  class Create < Reform::Form
    property :name
    property :priority
    property :website
    property :locations
    property :contact_people
    property :comment
    property :divisions

    validates :name, length: { maximum: 100 }, presence: true
    validates_uniqueness_of :name
    validates :website, presence: true
    # validates :location_ids, presence: true
    # validates :contact_person_ids, presence: true

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
