# frozen_string_literal: true

# Monkeypatch clarat_base Email
unless defined?(Email)
  require ClaratBase::Engine.root.join('app', 'models', 'email')
end

class Email < ApplicationRecord
  include ReformedValidationHack

  # Associations
  has_many :offer_mailings, inverse_of: :email
  has_many :known_offers, source: :offer, through: :offer_mailings,
                          inverse_of: :informed_emails

  # Search
  # include PgSearch
  # pg_search_scope :search_pg,
  #                 against: [:id, :address],
  #                 using: {
  #                   tsearch: { only: [:id], prefix: true },
  #                   trigram: { only: [:address], threshold: 0.3 }
  #                 }
  # NOTE Hack: use manual scope with LIKE query for containing search
  scope :search_pg, ->(input) {
    where('address LIKE ?', "%#{input}%").limit(30)
  }

  def create_tos_mailings offers
    offers.each do |offer|
      OfferMailing.create! offer_id: offer.id, email_id: id,
                           mailing_type: 'tos'
    end
  end

  def create_tos_accepted_mailings offers
    offers.each do |offer|
      OfferMailing.create! offer_id: offer.id, email_id: id,
                           mailing_type: 'tos_accepted'
    end
  end
end
