# frozen_string_literal: true

class CheckForNewTranslationsWorker
  include Sidekiq::Worker

  def perform
    # start async worker for every pending (existing) gengo order
    GengoOrder.pluck(:id).each do |gengo_order_id|
      GetAndApplyNewTranslationWorker.perform_async gengo_order_id
    end
  end
end
