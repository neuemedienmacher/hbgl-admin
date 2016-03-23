class CheckWebsitesWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options queue: :heavy_load
  recurrence { weekly.day(:wednesday).hour_of_day(20) }

  def perform
    # return # TODO: remove this to re-enable, also coverage and tests
    # Get websites to check (only those with approved offers or orgas)
    Website.select { |w| !w.offers.approved.empty? || !w.organizations.approved.empty? }.each do |website|
      CheckSingleWebsiteWorker.perform_async website.id
    end
  end
end
