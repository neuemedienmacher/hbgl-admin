# frozen_string_literal: true
class CheckWebsitesWorker
  include Sidekiq::Worker

  sidekiq_options queue: :heavy_load

  # rubocop:disable UnreachableCode
  def perform
    return # TODO: remove this to re-enable, also coverage and tests
    # Get websites to check (only those with approved offers or orgas)
    Website.select { |w| !w.offers.approved.empty? || !w.organizations.approved.empty? }.each do |website|
      CheckSingleWebsiteWorker.perform_async website.id
    end
  end
  # rubocop:enable UnreachableCode
end
