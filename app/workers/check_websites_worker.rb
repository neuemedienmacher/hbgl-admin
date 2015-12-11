class CheckWebsitesWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options queue: :heavy_load
  recurrence { weekly(1).day(:wednesday).hour_of_day(20) }

  def perform
    # Get websites to check (only those with approved offers)
    websites = Website.select { |website| !website.offers.approved.empty? }

    return if websites.empty?

    # worker = CheckSingleWebsiteWorker.new
    websites.each do |website|
      worker = CheckSingleWebsiteWorker.new
      worker.perform website
    end
  end
end
