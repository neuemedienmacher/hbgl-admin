# frozen_string_literal: true
class ExpiringOffersWorker
  include Sidekiq::Worker

  def perform
    # Find expiring offers
    expiring = Offer.approved.where('expires_at <= ?', Time.zone.today)
    return if expiring.count < 1

    # Create Asana Tasks
    asana = AsanaCommunicator.new
    expiring.find_each do |expiring_offer|
      asana.create_expire_task expiring_offer
    end

    # Info E-Mail - disabled because the new responsible team does not want them
    # OfferMailer.expiring_mail(expiring.count, expiring.pluck(:id)).deliver_now

    # Expire/pause offers and trigger manual indexing for algolia search
    expire_and_reindex_offers expiring
  end

  def expire_and_reindex_offers expiring
    # Save ids because the expiring relation does not work after update_all
    expiring_ids = expiring.pluck(:id)
    # Set to expired or paused
    expiring.each do |offer|
      # INFO: theses changes can't be events because the offers may be invalid
      # (exceeded expires_at date)
      if offer.starts_at?
        # seasonal offer => set paused instead of expired and advance dates
        offer.update_columns aasm_state: 'paused', starts_at: starts_at + 1.year,
                             expires_at: expires_at + 1.year
      else
        offer.update_columns aasm_state: 'expired'
      end
    end
    # Work on updated model with saved ids to sync algolia via manual index
    Offer.find(expiring_ids).each(&:index!)
  end
end
