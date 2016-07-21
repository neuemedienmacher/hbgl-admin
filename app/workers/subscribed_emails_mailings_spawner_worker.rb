# frozen_string_literal: true
# Worker to check bi-weekly, whether there are emails that
# - have subscribed to updates about new approved offers
# - have approved offers that do not yet have an OfferMailing
# and queue each of them to receive an email.
class SubscribedEmailsMailingsSpawnerWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1

  def perform
    # return # TODO: remove to reenable mailings (also rubocop, tests, cov filter and worker_schedule)
    Offer.transaction do
      Email.transaction do
        potentially_informable_emails.each do |email| # TODO: find_each later
          SubscribedEmailMailingWorker.perform_async email.id
        end
      end
    end
  end

  private

  # TODO: remove later: currently only send refugees-only-mailings
  def potentially_informable_emails
    Email.where(aasm_state: 'subscribed').uniq
         .joins(:offers).where('offers.aasm_state = ?', 'approved')
         .joins(:organizations).where(
           'organizations.mailings_enabled = ?', true).select { |mail| !mail.offers.approved.in_section('family').any? }
  end
end
