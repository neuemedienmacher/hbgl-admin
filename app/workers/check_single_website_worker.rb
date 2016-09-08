# frozen_string_literal: true
require 'httparty'

class CheckSingleWebsiteWorker
  include Sidekiq::Worker

  sidekiq_options queue: :heavy_load

  def perform website_id
    website = Website.find(website_id)
    if check_website_unreachable? website
      website.unreachable_count += 1
      # expire if counts as unreachable now (only once)
      expire_and_create_asana_tasks website if website.unreachable_count == 2
    else
      # reset count if website was reachable again
      website.unreachable_count = 0
    end
    website.save
  end

  private

  def expire_and_create_asana_tasks website
    asana = AsanaCommunicator.new
    # Create Asana Tasks, set state to expired and manually reindex for algolia
    website.offers.approved.find_each do |broken_link_offer|
      asana.create_website_unreachable_task_offer website, broken_link_offer
      # Force-Set state change to avoid (rare) problems with invalid offers
      broken_link_offer.update_columns(aasm_state: 'website_unreachable')
      broken_link_offer.index!
    end
    # approved organizations => only create one task for all organizations
    unless website.organizations.approved.empty?
      asana.create_website_unreachable_task_orgas website
    end
  end

  def check_website_unreachable? website
    url = website.ascii_url
    # first check header then try complete get when header returns an error.
    # If both checks fail, the website is treated as unreachable
    header = HTTParty.head(url)
    if !header || header.code >= 400 # everything above 400 is an error
      response = HTTParty.get(url)
      if !response || response.code >= 400 # everything above 400 is an error
        return true
      end
    end
    return false
  # catch errors that prevent a valid response
  rescue HTTParty::RedirectionTooDeep, Errno::EHOSTUNREACH, SocketError,
         Timeout::Error, URI::InvalidURIError, OpenSSL::SSL::SSLError
    return true
  end
end
