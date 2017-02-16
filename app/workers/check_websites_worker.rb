# frozen_string_literal: true
class CheckWebsitesWorker
  include Sidekiq::Worker

  sidekiq_options queue: :heavy_load

  def perform
    Website.find_each do |website|
      next unless website.unreachable? ||
                  website.offers.visible_in_frontend.any? ||
                  website.organizations.visible_in_frontend.any?
      CheckSingleWebsiteWorker.perform_async website.id
    end
  end
end
