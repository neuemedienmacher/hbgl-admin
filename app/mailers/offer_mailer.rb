# frozen_string_literal: true
# rubocop:disable Metrics/ClassLength
class OfferMailer < ActionMailer::Base
  add_template_helper(EmailHelper)
  MAX_OFFER_TEASER_COUNT = 5

  # not needed at the moment but maybe later..
  # def expiring_mail offer_count, offer_ids
  #   @offer_count = offer_count
  #   @offer_ids = offer_ids
  #   mail subject: 'expiring offers',
  #        to:      Rails.application.secrets.emails['expiring'],
  #        from:    'post@clarat.org'
  # end

  # Informing email addresses for the first time that they have offers listed on
  # our platform.
  # @attr email Email object this is sent to
  # @attr offers variable only for test mails
  # A lot of variables have to be prepared for the email, so we are OK with
  # a slightly higher assignment branch condition size and disable rubocop
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def inform_offer_context email, offers = nil
    # Loads of variables in preparation for view models
    @contact_person = email.contact_people.first
    usable_offers = offers || email.offers.visible_in_frontend.by_mailings_enabled_organization
                                   .select(&:remote_or_belongs_to_informable_city?)
    offers_per_section = get_offers_per_section usable_offers
    @offers = get_offer_teaser offers_per_section
    @offers_teaser = are_offers_teaser? offers_per_section
    @section_suffix = get_section_suffix usable_offers, offers_per_section
    @singular_section = singular_section? @section_suffix
    @subscribe_href = get_sub_or_unsub_href email, 'subscribe'
    @overview_href_suffix = "/emails/#{email.id}/angebote"
    @utm_tagging_suffix = generate_utm_suffix usable_offers, 'AO'
    @vague_title = email.vague_contact_title?
    @mainly_portal = mainly_portal_offers? usable_offers
    headers['X-SMTPAPI'] = { 'category': ['inform offer', @section_suffix] }.to_json
    send_emails email, usable_offers, :inform, t(".subject.#{@section_suffix}")
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # Mails to organization conctacts to inform them about clarat
  # @attr email Email object this is sent to
  # A lot of variables have to be prepared for the email, so we are OK with
  # a slightly higher assignment branch condition size and disable rubocop
  # rubocop:disable Metrics/AbcSize
  def inform_organization_context email
    # okay, because all contact_persons belong to the same organization
    orga = email.contact_people.first.organization
    offers = orga.offers.visible_in_frontend.select(&:remote_or_belongs_to_informable_city?)
    @contact_person = email.contact_people.first
    @vague_title = email.vague_contact_title?
    @mainly_portal = mainly_portal_offers?(offers)
    @overview_href_suffix = "/organisationen/#{orga.slug || orga.id.to_s}"
    @utm_tagging_suffix = generate_utm_suffix orga.offers, 'GF'
    @subscribe_href = get_sub_or_unsub_href email, 'subscribe'
    headers['X-SMTPAPI'] = { category: ['inform orga'] }.to_json
    send_emails email, offers, :orga_inform, t('.subject')
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
    @vague_title = email.vague_contact_title?
    @overview_href_suffix = "/emails/#{email.id}/angebote"
    @utm_tagging_suffix = generate_utm_suffix offers, 'AO', 'FU'
    headers['X-SMTPAPI'] = { category: ['newly approved offer', @section_suffix] }.to_json
    send_emails email, offers, :newly_approved,
                t('.subject', count: offers.count,
                              name: t(".clarat_name_subject.#{@section_suffix}"))
  end
  # rubocop:enable Metrics/AbcSize

  private

  def send_emails email, offers, mailing_type, subject
    email.create_offer_mailings offers, mailing_type
    mail subject: subject, to: email.address,
         from: 'clarat-Team <post@clarat.org>'
  end

  def get_section_suffix offers, offers_hash = nil
    offers_per_section = offers_hash || get_offers_per_section(offers)
    offers_per_section.map { |k, v| k unless v.empty? }.compact.sort.join('_')
  end

  def are_offers_teaser? offers_per_section
    offers_per_section.values.flatten.count > MAX_OFFER_TEASER_COUNT
  end

  def singular_section? section_suffix
    section_suffix.index('_').nil?
  end

  def get_sub_or_unsub_href email, sub_or_unsub
    "http://www.clarat.org/emails/#{email.id}/#{sub_or_unsub}/#{email.security_code}"
  end

  # creates a link for a single offer with bias to refugees section
  def get_offer_href_for_single_offer offer, section_suffix
    "http://www.clarat.org/#{section_suffix.split('_').last}/angebote/#{offer.slug || offer.id.to_s}"
  end

  # this method retrieves max_count offers out of offers_hash, distributing the
  # offers from both sections evenly and filling it up with offers from the
  # other section if one has too few offers.. designed for uneven max_count!
  # Not pretty but it gets the job done..
  def get_offer_teaser offers_hash
    sorted_sects = get_section_names_sorted_by_offer_count offers_hash
    teasing_offers = [
      *offers_hash[sorted_sects[0]][0..(MAX_OFFER_TEASER_COUNT / 2)]
    ]
    teasing_offers.push(
      *offers_hash[sorted_sects[1]][0..(MAX_OFFER_TEASER_COUNT -
        teasing_offers.count - 1)]
    ).uniq
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

  # over a certain treshold (currently 60%) the mailing is treated as a
  # mainly-portal-mailing with some content changes
  def mainly_portal_offers? offers
    (offers.map { |o| o if o.encounter == 'portal' }.compact.count.to_f /
      offers.count.to_f) >= 0.6
  end

  # Method to generate a custom utm-tag-suffix for the links in our mailings.
  # Includes information about the worlds, the offer-count of the mailing, the
  # type and the receiver of the mailing.
  def generate_utm_suffix offers, receiver_type, mailing_type = 'OB'
    sections = offers.map { |o| o.section_filters.pluck(:identifier).flatten }.flatten.uniq
    first_char_of_sections = sections.map { |w| w.first.upcase }.sort.join
    offers_text =
      if offers.count == 1
        'E'
      else
        offers.count < 5 ? 'EP' : 'FP'
      end
    '?utm_source=Sendgrid&utm_medium=E-Mail&utm_campaign='\
    "#{first_char_of_sections}_#{receiver_type}_#{offers_text}_#{mailing_type}"
  end
end
# rubocop:enable Metrics/ClassLength
