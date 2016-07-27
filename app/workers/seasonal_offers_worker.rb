# frozen_string_literal: true
class SeasonalOffersWorker
  include Sidekiq::Worker

  def perform
    # check seasonal_pending offers and try to approve them
    Offer.where(aasm_state: 'seasonal_pending').find_each do |pending_offer|
      if pending_offer.may_approve?
        pending_offer.approve!
      else
        # TODO do something in this case? AsanaTask?
      end
    end

    # check paused seasonal offers and create AsanaTask 30 days in advance
    asana = AsanaCommunicator.new
    Offer.where(aasm_state: 'paused').find_each do |paused_offer|
      if (Time.zone.now + 30.days).to_date == paused_offer.starts_at.to_date
        asana.create_seasonal_offer_ready_for_checkup_task paused_offer
      end
    end
  end
end
