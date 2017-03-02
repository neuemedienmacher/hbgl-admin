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
        potentially_informable_emails.find_each do |email|
          SubscribedEmailMailingWorker.perform_async email.id
        end
      end
    end
  end

  private

  def potentially_informable_emails
    Email.where(aasm_state: 'subscribed').uniq
         .joins(:offers).where('offers.aasm_state = ? OR offers.aasm_state = ?', 'approved', 'expired')
         .joins(:organizations).where('organizations.mailings = ?', 'enabled')
         .joins(:organizations).where('organizations.aasm_state = ?', 'all_done')
  end
end
