# frozen_string_literal: true
class CheckWebsitesWorker
  include Sidekiq::Worker

  sidekiq_options queue: :heavy_load

  def perform
    # ignore facebook because it seems to block the crawler leading to false positives
    Website.where.not(host: 'facebook').find_each do |website|
      next unless website.unreachable? || website.offers.approved.any? ||
                  website.organizations.approved.any?
      CheckSingleWebsiteWorker.perform_async website.id
    end
  end
end
