# frozen_string_literal: true
# Worker to check bi-weekly, whether there are emails that
# - have not yet been informed
# - have approved offers
# - belongs to at least one organization that has `mailings_enabled: true`
# and spawn an informer worker for them. trigger their inform event to send them a mailing each.
class UninformedEmailsMailingsSpawnerWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { weekly(2).day(:monday).hour_of_day(20).minute_of_hour(30) }
  sidekiq_options retry: 0

  def perform
    # return # TODO: remove to reenable mailings (also rubocop, tests, cov filter)
    Offer.transaction do
      Email.transaction do
        informable_emails =
          (informable_offer_emails + informable_orga_emails).uniq

        informable_emails.each do |email|
          UninformedEmailMailingWorker.perform_async email.id
        end
      end
    end
  end

  private

  def informable_offer_emails
    Email.where(aasm_state: 'uninformed').uniq
         .joins(:offers).where('offers.aasm_state = ?', 'approved')
         .joins(:organizations).where(
           'organizations.mailings_enabled = ?', true)
  end

  def informable_orga_emails
    Email.where(aasm_state: 'uninformed')
         .select(&:belongs_to_unique_orga_with_orga_contact?)
  end
end
