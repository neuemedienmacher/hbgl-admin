# frozen_string_literal: true
class ExpiringOffersWorker
  include Sidekiq::Worker

  def perform
    # Find expiring offers (ignore seasonal offers - another worker handles these)
    expiring = Offer.approved.where('expires_at <= ? AND starts_at IS null',
                                    Time.zone.today)
    return if expiring.count < 1

    # Create Asana Tasks
    asana = AsanaCommunicator.new
    expiring.find_each do |expiring_offer|
      asana.create_expire_task expiring_offer
    end

    # Info E-Mail - disabled because the new responsible team does not want them
    # OfferMailer.expiring_mail(expiring.count, expiring.pluck(:id)).deliver_now

    # Expire offers and trigger manual indexing for algolia search
    expire_and_reindex_offers expiring
  end

  def expire_and_reindex_offers expiring
    # Save ids because the expiring relation does not work after update_all
    expiring_ids = expiring.pluck(:id)
    # Set to expired
    # INFO: theses changes can't be events because the offers may be invalid
    # (exceeded expires_at date)
    expiring.update_all aasm_state: 'expired'
    # Work on updated model with saved ids to sync algolia via manual index
    Offer.find(expiring_ids).each(&:index!)
  end
end
