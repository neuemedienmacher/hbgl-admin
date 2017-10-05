# frozen_string_literal: true
class CheckUnreachableOffersWorker
  include Sidekiq::Worker

  sidekiq_options queue: :heavy_load

  def perform
    Offer.where(aasm_state: 'website_unreachable').find_each do |offer|
      # ignore invalid offers and those with an unreachable website
      next unless offer.valid? && !offer.websites.empty? &&
                  offer.websites.unreachable_and_not_ignored.empty?
      # otherwise => re-activate offer (valid and all websites reachable)
      offer.update_columns aasm_state: 'approved'
      offer.index!
    end
  end
end
