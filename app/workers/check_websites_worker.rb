require 'httparty'

class CheckWebsitesWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options queue: :heavy_load
  recurrence { weekly(1).day(:monday).hour_of_day(1) }

  def perform
    # Get websites to check (only those with approved offers)
    websites = Website.select { |website| !website.offers.approved.empty? }

    return if websites.empty?

    # Check websites for invalids and get affected offers
    affected_offers = []
    websites.each do |website|
      affected_offers.push(*check_website_and_get_affected_offers(website))
    end

    # Create Asana Tasks, set state to expired and manually reindex for algolia
    asana = AsanaCommunicator.new
    affected_offers.compact.each do |expiring_offer|
      asana.create_expire_task expiring_offer, '[URL unreachable]'
      expiring_offer.update_columns(aasm_state: 'expired')
      expiring_offer.index!
    end
  end

  private

  def check_website_and_get_affected_offers website
    # get website and check for error codes
    response = HTTParty.get(website.url)
    if !response || response.code >= 400 # everything above 400 is an error
      return website.offers.approved.to_a
    end
    []
  # catch errors that prevent a valid response
  rescue HTTParty::RedirectionTooDeep, Errno::EHOSTUNREACH, SocketError,
         Timeout::Error
    return website.offers.approved.to_a
  end
end
