# Monkeypatch clarat_base Offer
require ClaratBase::Engine.root.join('app', 'models', 'offer')

class Offer < ActiveRecord::Base
  has_paper_trail

  # Associations
  has_many :offer_mailings, inverse_of: :offer
  has_many :informed_emails, source: :email, through: :offer_mailings,
                             inverse_of: :known_offers

  # Scopes
  scope :approved, -> { where(aasm_state: 'approved') }
  scope :by_mailings_enabled_organization, lambda {
    joins(:organizations).where('organizations.mailings_enabled = ?', true)
  }

  # Admin specific methods

  # Customize duplication.
  # Lots of configs here, so we are OK with a longer method:
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def partial_dup
    self.dup.tap do |offer|
      offer.created_by = nil
      offer.location = self.location
      offer.organizations = self.organizations
      offer.openings = self.openings
      offer.categories = self.categories
      offer.section_filters = self.section_filters
      offer.language_filters = self.language_filters
      offer.target_audience_filters = self.target_audience_filters
      offer.websites = self.websites
      offer.contact_people = self.contact_people
      offer.keywords = self.keywords
      offer.area = self.area
      offer.aasm_state = 'initialized'
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
