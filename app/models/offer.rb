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
end
