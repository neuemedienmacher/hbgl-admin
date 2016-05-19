# frozen_string_literal: true
# Send an email address a compound email about new offers.
class SubscribedEmailMailingWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { weekly(2).day(:monday).hour_of_day(20) }
  sidekiq_options retry: 1

  def perform email_id
    OfferMailing.transaction do
      Email.transaction do
        email = Email.find(email_id)
        informable_offers = email.not_yet_but_soon_known_offers
        next if informable_offers.empty?
        OfferMailer.newly_approved_offers(email, informable_offers).deliver_now
      end
    end
  end
end
