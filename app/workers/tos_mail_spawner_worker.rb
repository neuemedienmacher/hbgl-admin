# frozen_string_literal: true

class TosMailSpawnerWorker
  include Sidekiq::Worker

  sidekiq_options retry: 0

  def perform
    Offer.transaction do
      Email.transaction do
        informable_emails = informable_offer_emails.uniq

        informable_emails.each do |email|
          TosMailWorker.perform_async email.id
        end
      end
    end
  end

  private

  def informable_offer_emails
    Email.where(tos: 'uninformed').distinct
         .joins(:offers).where('offers.aasm_state = ? OR offers.aasm_state = ?',
                               'approved',
                               'expired')
  end
end
