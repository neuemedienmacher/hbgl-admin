class ExpiringOffersWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(3) }

  def perform
    # Find expiring offers
    expiring = Offer.approved.where('expires_at <= ?', Time.zone.today)
    return if expiring.count < 1

    # Create Asana Tasks
    asana = AsanaCommunicator.new
    expiring.find_each do |expiring_offer|
      asana.create_expire_task expiring_offer
    end

    # Info E-Mail
    OfferMailer.expiring_mail(expiring.count, expiring.pluck(:id)).deliver

    # Expire offers and trigger manual indexing for algolia search
    expire_and_reindex_offers expiring
  end

  def expire_and_reindex_offers expiring
    # Save ids because the expiring relation does not work after update_all
    expiring_ids = expiring.pluck(:id)
    # Set to expired
    expiring.update_all aasm_state: 'expired' # TODO: should this be event?
    # Work on updated model with saved ids to sync algolia via manual index
    Offer.find(expiring_ids).each(&:index!)
  end
end
