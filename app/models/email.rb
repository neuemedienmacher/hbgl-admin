# Monkeypatch clarat_base Email
require ClaratBase::Engine.root.join('app', 'models', 'email')

class Email < ActiveRecord::Base
  # Associations
  has_many :offer_mailings, inverse_of: :email
  has_many :known_offers, source: :offer, through: :offer_mailings,
                          inverse_of: :informed_emails

  # State Machine
  aasm do
    state :informed, # An offer has been approved and the owner got sent info
          after_enter: :send_information
  end

  # Methods
  def not_yet_but_soon_known_offers
    offers.approved.by_mailings_enabled_organization.all - known_offers.all
  end

  def create_offer_mailings offers, mailing_type
    offers.each do |offer|
      OfferMailing.create! offer_id: offer.id, email_id: id,
                           mailing_type: mailing_type
    end
  end

  def send_information
    OfferMailer.inform(self).deliver
  end
end
