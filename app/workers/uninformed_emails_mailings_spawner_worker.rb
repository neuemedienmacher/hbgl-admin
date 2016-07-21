# frozen_string_literal: true
# Worker to check bi-weekly, whether there are emails that
# - have not yet been informed
# - have approved offers
# - belongs to at least one organization that has `mailings_enabled: true`
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

  # TODO: remove later: currently only send mailings to offers of refugees-only-orgas
  def informable_offer_emails
    Email.where(aasm_state: 'uninformed').uniq
         .joins(:offers).where('offers.aasm_state = ?', 'approved')
         .joins(:organizations)
         .where('organizations.mailings_enabled = ?', true)
         .select do |mail|
           !mail.organizations.select do |o|
             o.section_filters.where(identifier: 'family').any?
           end.compact.any?
         end
  end

  # TODO: remove later: currently only send refugees-only-mailings
  def informable_orga_emails
    Email.where(aasm_state: 'uninformed')
         .select do |mail|
           mail.belongs_to_unique_orga_with_orga_contact? &&
             !mail.organizations.select do |o|
               o.section_filters.where(identifier: 'family').any?
             end.compact.any?
         end
    # .select(&:belongs_to_unique_orga_with_orga_contact?)
  end
end
