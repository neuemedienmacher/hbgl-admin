require 'httparty'

class CheckSingleWebsiteWorker
  include Sidekiq::Worker

  sidekiq_options queue: :heavy_load

  def perform website_id
    website = Website.find(website_id)
    return unless website && !website.offers.approved.empty?
    if website_unreachable? website
      # Create Asana Tasks, set state to expired and manually reindex for algolia
      asana = AsanaCommunicator.new
      website.offers.approved.each do |expiring_offer|
        # asana.create_expire_task expiring_offer, '[URL unreachable]'
        # expiring_offer.update_columns(aasm_state: 'expired')
        # expiring_offer.index!
      end
    end
  end

  private

  def website_unreachable? website
    puts website.url
    # get website and check for error codes
    response = HTTParty.get(website.url)
    if !response || response.code >= 400 # everything above 400 is an error
      return true
    end
    return false
  # catch errors that prevent a valid response
  rescue HTTParty::RedirectionTooDeep, Errno::EHOSTUNREACH, SocketError,
         Timeout::Error, URI::InvalidURIError
    return true
  end
end
