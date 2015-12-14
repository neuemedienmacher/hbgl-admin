class CheckWebsitesWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options queue: :heavy_load
  recurrence { weekly(1).day(:wednesday).hour_of_day(20) }

  def perform
    # Get websites to check (only those with approved offers or orgas)
    Website.select { |w| !w.offers.approved.empty? || !w.organizations.approved.empty? }.each do |website|
      CheckSingleWebsiteWorker.perform_async website.id
    end
  end
end
