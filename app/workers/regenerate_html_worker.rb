# frozen_string_literal: true
class RegenerateHtmlWorker
  include Sidekiq::Worker

  def perform
    Offer.visible_in_frontend.find_each do |offer|
      TranslationGenerationWorker.perform_async :de, 'Offer', offer.id
    end

    Organization.visible_in_frontend.find_each do |orga|
      TranslationGenerationWorker.perform_async :de, 'Organization', orga.id
    end
  end
end
