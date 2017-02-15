# frozen_string_literal: true
# Worker to check weekly, whether there are emails that
# - have not yet been informed
# - have approved offers
# - belongs to at least one organization that has `mailings = enabled`
# and spawn an informer worker for them. trigger their inform event to send them a mailing each.
class UninformedEmailsMailingsSpawnerWorker
  include Sidekiq::Worker

  sidekiq_options retry: 0

  def perform
    # return # TODO: remove to reenable mailings (also rubocop, tests, cov filter and worker_schedule)
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
         .joins(:offers).where('offers.aasm_state = ? OR offers.aasm_state = ?', 'approved', 'expired')
         .joins(:organizations)
         .where('organizations.mailings = ?', 'enabled')
         .where('organizations.aasm_state = ?', 'all_done')
         .select(&:belongs_to_at_least_one_informable_offer?)
  end

  def informable_orga_emails
    Email.where(aasm_state: 'uninformed')
         .select(&:belongs_to_unique_orga_with_orga_contact?)
  end
end
