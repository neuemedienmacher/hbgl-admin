# frozen_string_literal: true
class SeasonalOffersWorker
  include Sidekiq::Worker

  def perform
    today = Time.zone.today
    # check paused seasonal offers and create AsanaTask 30 days in advance
    asana = AsanaCommunicator.new
    Offer.where(aasm_state: 'paused').find_each do |paused_offer|
      if (Time.zone.now + 30.days).to_date == paused_offer.starts_at.to_date
        asana.create_seasonal_offer_ready_for_checkup_task paused_offer
      end
    end

    # set approved seasonal offers to paused if they left their TimeFrame
    # no AsanaTask, no mailing, just pause the offers
    Offer.approved.seasonal.where('expires_at <= ?', today).find_each do |offer|
      # set paused instead of expired and advance dates
      offer.update_columns aasm_state: 'paused',
                           starts_at: offer.starts_at + 1.year,
                           expires_at: offer.expires_at + 1.year
      offer.index!
    end

    # check seasonal_pending offers and force-approve them. No callbacks, so
    # the logic_version stays the same (might be outdated). Also approved_at and
    # approved_by don't get overwritten, which is good!
    Offer.where(aasm_state: 'seasonal_pending').
         where('starts_at = ?', today).find_each do |offer|
      offer.update_columns aasm_state: 'approved'
      offer.index!
    end
  end
end
