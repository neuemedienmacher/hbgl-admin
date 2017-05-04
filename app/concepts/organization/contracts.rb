# frozen_string_literal: true
module Organization::Contracts
  class Create < Reform::Form
    property :name
    property :priority
    property :website_id
    property :location_ids
    property :contact_person_ids
    property :comment
    property :division_ids

    # validates :website_id, presence: true
    # validates :location_ids, presence: true
    # validates :category_ids, presence: true
    # validates :solution_category_ids, presence: true

    validates :name, length: { maximum: 100 }, presence: true
    validates_uniqueness_of :name

    # validate :validate_websites_hosts
    # validate :must_have_umbrella_filter
    #
    # def validate_websites_hosts
    #   websites.where.not(host: 'own').each do |website|
    #     errors.add(
    #       :base,
    #       I18n.t('organization.validations.website_host', website: website.url)
    #     )
    #   end
    # end
    #
    # def must_have_umbrella_filter
    #   if umbrella_filters.empty?
    #     fail_validation :umbrella_filters, 'needs_umbrella_filters'
    #   end
    # end
  end

  # validates :slug, uniqueness: true
  # validates :mailings, presence: true

  class Update < Reform::Form
    property :description
    property :legal_form
    property :charitable
    property :accredited_institution
    property :founded
    property :umbrella___
    validates :founded, length: { is: 4 }, allow_blank: true

    # validate :validate_hq_location, on: :update
    #
    # def validate_hq_location
    #   if locations.to_a.count(&:hq) != 1
    #     errors.add(:base, I18n.t('organization.validations.hq_location'))
    #   end
    # end
  end

  class Approve < Reform::Form
    validates :description, presence: true
    validates :legal_form, presence: true
  end
end
