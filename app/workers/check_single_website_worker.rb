# frozen_string_literal: true

class CheckSingleWebsiteWorker
  include Sidekiq::Worker

  sidekiq_options queue: :heavy_load

  def perform website_id
    website = Website.find(website_id)
    if check_website_unreachable? website
      website.unreachable_count += 1
      # expire if counts as unreachable now (only once)
      expire_and_create_assignments website if website.unreachable_count == 2
    else
      # reset count if website was reachable again
      website.unreachable_count = 0
    end
    website.save
  end

  private

  def expire_and_create_assignments website
    if website.organizations.visible_in_frontend.any?
      create_assignment website, 'Orga'
    elsif website.offers.visible_in_frontend.any?
      create_assignment website, 'Offer'
    end
  end

  def create_assignment website, model
    message = "[#{model}-website unreachable] | #{website.url}"
    ::Assignment::CreateBySystem.({}, assignable: website,
                                      last_acting_user: User.system_user,
                                      message: message)
    update_offers(website.offers.visible_in_frontend)
  end

  def update_offers online_offers
    online_offers.find_each do |offer|
      # Force-Set state change to avoid (rare) problems with invalid offers
      offer.update_columns(aasm_state: 'website_unreachable')
      offer.index!
    end
  end

  def check_website_unreachable? website
    url = website.ascii_url
    # check the url with Faraday and HTTParty+Cipher. Returns true only when
    # both checks must classify the URL as unreachable (return true)
    url_unreachable_with_faraday?(url) && url_unreachable_with_httparty?(url)
  end

  def url_unreachable_with_httparty? url
    header = HttpWithCipher.head(url)
    if !header || header.code >= 400 # everything above 400 is an error
      response = HttpWithCipher.get(url)
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

  def url_unreachable_with_faraday? url
    connection = create_faraday_connection
    header = connection.head(url)
    if !header || header.status >= 400 # everything above 400 is an error
      response = connection.get(url)
      if !response || response.status >= 400 # everything above 400 is an error
        return true
      end
    end
    return false
  # catch errors that prevent a valid response
  rescue Faraday::ConnectionFailed, Faraday::TimeoutError, Errno::EHOSTUNREACH,
         SocketError, URI::InvalidURIError, Faraday::SSLError,
         FaradayMiddleware::RedirectLimitReached
    return true
  end

  def create_faraday_connection
    # Faraday connection with middleware to follow <= 30 redirects
    Faraday.new headers: { accept_encoding: 'none' } do |conn|
      conn.use FaradayMiddleware::FollowRedirects, limit: 30
      conn.adapter :net_http
    end
  end
end
