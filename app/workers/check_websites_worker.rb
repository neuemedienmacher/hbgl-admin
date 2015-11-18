require 'httparty'

class CheckWebsitesWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { weekly(1).day(:sunday).hour_of_day(23) }

  def perform
    # Get websites to check (only those with approved offers)
    websites = Website.select { |website| !website.offers.approved.empty? }

    return if websites.empty?

    # Check websites for invalids and get affected offers
    affected_offers = check_websites_and_get_affected_offers websites

    # Create Asana Tasks, set state to expired and manually reindex for algolia
    asana = AsanaCommunicator.new
    affected_offers.each do |expiring_offer|
      asana.create_expire_task expiring_offer, '[URL unreachable]'
      expiring_offer.update_columns(aasm_state: 'expired')
      expiring_offer.index!
    end
  end

  private

  def check_websites_and_get_affected_offers websites
    affected_offers = []
    websites.each do |website|
      # get website and check for error codes
      begin
        response = HTTParty.get(website.url)
        if !response || response.code >= 400 # everything above 400 is an error
          affected_offers.push(*website.offers.approved.to_a)
        end
      # catch errors that prevent a valid response
      rescue HTTParty::RedirectionTooDeep, Errno::EHOSTUNREACH, SocketError,
             Timeout::Error
        affected_offers.push(*website.offers.approved.to_a)
      end
    end
    affected_offers.compact
  end
end
