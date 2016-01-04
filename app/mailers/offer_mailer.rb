class OfferMailer < ActionMailer::Base
  MAX_OFFER_TEASER_COUNT = 5

  def expiring_mail offer_count, offer_ids
    @offer_count = offer_count
    @offer_ids = offer_ids
    mail subject: 'expiring offers',
         to:      Rails.application.secrets.emails['expiring'],
         from:    'post@clarat.org'
  end

  # Informing email addresses for the first time that they have offers listed on
  # our platform.
  # @attr email Email object this is sent to
  # @attr offers variable only for test mails
  # A lot of variables have to be prepared for the email, so we are OK with
  # a slightly higher assignment branch condition size and disable rubocop
  # rubocop:disable Metrics/AbcSize
  def inform email, offers = nil
    # Loads of variables in preparation for view models (TODO)
    @contact_person = email.contact_people.first
    usable_offers = offers || email.offers.approved.by_mailings_enabled_organization
    offers_per_section = get_offers_per_section usable_offers
    @offers = get_offer_teaser offers_per_section
    @offers_teaser = are_offers_teaser? offers_per_section
    @section_suffix = get_section_suffix usable_offers, offers_per_section
    @singular_section = singular_section? @section_suffix
    @subscribe_href = get_sub_or_unsub_href email, 'subscribe'
    @overview_href_suffix = "/emails/#{email.id}/angebote"
    @vague_title = contact_vague_title? email.contact_people

    send_emails email, usable_offers, :inform, t(".subject.#{@section_suffix}")
    # email.create_offer_mailings @offers, :inform
    # mail subject: t(".subject.#{@section_suffix}"),
    #      to: email.address,
    #      from: 'Anne Schulze | clarat <anne.schulze@clarat.org>'
  end
  # rubocop:enable Metrics/AbcSize

  # Inform email addresses about new offers after they have subscribed.
  # A lot of variables have to be prepared for the email, so we are OK with
  # a slightly higher assignment branch condition size and disable rubocop
  # rubocop:disable Metrics/AbcSize
  def newly_approved_offers email, offers
    @contact_person = email.contact_people.first
    @offer = offers.count == 1 ? offers.first : nil
    @section_suffix = get_section_suffix offers
    @unsubscribe_href = get_sub_or_unsub_href email, 'unsubscribe'
    @offer_href = get_offer_href_for_single_offer offers.first, @section_suffix
    @vague_title = contact_vague_title? email.contact_people
    @overview_href_suffix = "/emails/#{email.id}/angebote"

    send_emails email, offers, :newly_approved,
                t('.subject', count: offers.count,
                              name: t(".clarat_name_subject.#{@section_suffix}"))
    # email.create_offer_mailings offers, :newly_approved
    # mail subject: t('.subject', count: @offers_count,
    #                             name: t(".clarat_name_subject.#{@section_suffix}")),
    #      to: email.address,
    #      from: 'Anne Schulze | clarat <anne.schulze@clarat.org>'
  end
  # rubocop:enable Metrics/AbcSize

  private

  def send_emails email, offers, mailing_type, subject
    email.create_offer_mailings offers, mailing_type
    mail subject: subject,
         to: email.address,
         from: 'Anne Schulze | clarat <anne.schulze@clarat.org>'
  end

  def get_section_suffix offers, offers_hash = nil
    offers_per_section = offers_hash || get_offers_per_section(offers)
    offers_per_section.map { |k, v| k unless v.empty? }.compact.sort.join('_')
  end

  def contact_vague_title? contact_people
    contact_person = contact_people.first
    contact_people.count > 1 || !contact_person.gender || (!contact_person.last_name? && !contact_person.first_name?)
  end

  def are_offers_teaser? offers_per_section
    offers_per_section.values.flatten.count > MAX_OFFER_TEASER_COUNT
  end

  def singular_section? section_suffix
    section_suffix.index('_').nil?
  end

  def get_sub_or_unsub_href email, sub_or_unsub
    "http://www.clarat.org/emails/#{email.id}/#{sub_or_unsub}"\
    "/#{email.security_code}"
  end

  # creates a link for a single offer with bias to refugees section
  def get_offer_href_for_single_offer offer, section_suffix
    "http://www.clarat.org/#{section_suffix.split('_').last}/angebote/"\
    "#{offer.slug || offer.id.to_s}"
  end

  # this method retrieves max_count offers out of offers_hash, distributing the
  # offers from both sections evenly and filling it up with offers from the
  # other section if one has too few offers.. designed for uneven max_count!
  # Not pretty but it gets the job done..
  def get_offer_teaser offers_hash
    teasing_offers = []
    sorted_sects = get_section_names_sorted_by_offer_count offers_hash
    teasing_offers.push(
      *offers_hash[sorted_sects[0]][0..(MAX_OFFER_TEASER_COUNT / 2)]
    )
    teasing_offers.push(
      *offers_hash[sorted_sects[1]][0..(MAX_OFFER_TEASER_COUNT - teasing_offers.count - 1)]
    )
    teasing_offers.uniq
  end

  def get_section_names_sorted_by_offer_count offers_hash
    offers_hash['family'].count < offers_hash['refugees'].count ? %w(family refugees) : %w(refugees family)
  end

  def get_offers_per_section offers
    return [] unless offers && !offers.empty?
    offers_per_section = {}
    SectionFilter.pluck(:identifier).each do |filter|
      section_offers = offers.map { |o| o if o.in_section? filter }.compact
      offers_per_section[filter] = section_offers
    end
    offers_per_section
  end
end
