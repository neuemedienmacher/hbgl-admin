class CheckWebsitesWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { weekly(1).day(:sunday).hour_of_day(23) }

  def perform
    # Get websites to check
    websites = Website.select{|site| !site.offers.approved.empty? and
                                     site.host == 'own'}
    # Check websites and store invalids
    invalid_websites = check_websites(websites)

    # Get offers affected by invalid websites
    affected_offers = invalid_websites.map{|site| site.offers.approved}.compact

    puts affected_offers

    # Create Asana Tasks
    #asana = AsanaCommunicator.new
    #expiring.each do |expiring_offer|
    #  asana.create_expire_task expiring_offer
    #end

    # Expire offers and trigger manual indexing for algolia search
    #expire_and_reindex_offers affected_offers
  end

  private

  def check_websites websites
    invalid_websites = []
    websites.each do |website|
      next unless website.url
      # get website and check for 404 errorcode
      begin
        puts website.url
        response = HTTParty.get(website.url)
        if response && response.code == 404
          invalid_websites << website
        end
      # catch errors that prevent a valid response
      rescue HTTParty::RedirectionTooDeep, Errno::EHOSTUNREACH, SocketError
        invalid_websites << website
      end
    end
    invalid_websites
  end

  def expire_and_reindex_offers expiring
    # Save ids because the expiring relation does not work after update_all
    expiring_ids = expiring.pluck(:id)
    # Set to expired
    expiring.update_all aasm_state: 'internal_review'
    # Work on updated model with saved ids to sync algolia via manual index
    Offer.find(expiring_ids).each(&:index!)
  end

end
