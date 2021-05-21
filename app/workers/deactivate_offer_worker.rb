# frozen_string_literal: true

# Deactivates a visible offer and re-indexes Algolia accordingly
class DeactivateOfferWorker
  include Sidekiq::Worker

  def perform offer_id
    offer = Offer.find offer_id
    if offer.visible_in_frontend?
      offer.update_columns aasm_state: 'external_feedback'
      offer.index!
    end
  end
end
