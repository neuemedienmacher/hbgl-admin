# frozen_string_literal: true

class ExpiringOffersWorker
  include Sidekiq::Worker

  def perform
    # Find expiring offers (ignore seasonal offers -
    # another worker handles these)
    expiring = Offer.should_be_expired.where(aasm_state: 'approved')
    return if expiring.count < 1

    # Create Asana Tasks
    asana = AsanaCommunicator.new
    expiring.find_each do |expiring_offer|
      asana.create_expire_task expiring_offer
    end

    # Info E-Mail - disabled because the new responsible team does not want them
    # OfferMailer.expiring_mail(expiring.count, expiring.pluck(:id)).deliver_now

    # Expire offers and trigger manual indexing for algolia search
    # NOTE: reindex no longer needed: expired offers remain in frontend
    expiring.update_all aasm_state: 'expired'
  end
end
