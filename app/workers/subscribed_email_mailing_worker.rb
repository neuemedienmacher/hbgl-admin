# frozen_string_literal: true

# Send an email address a compound email about new offers.
class SubscribedEmailMailingWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1

  def perform email_id
    OfferMailing.transaction do
      Email.transaction do
        email = Email.find(email_id)
        informable_offers = email.newly_approved_offers_from_offer_context
        next if informable_offers.empty?
        OfferMailer.newly_approved_offers(email, informable_offers).deliver_now
      end
    end
  end
end
