# frozen_string_literal: true
class RegenerateHtmlWorker
  include Sidekiq::Worker

  def perform
    offers = []
    organizations = []

    Definition.where('updated_at > ?', 7.days.ago).each do |definition|
      definition.key.split(',').map(&:strip).each do |key|
        key_search_string = '\m' + key.downcase + '\M'
        offers |= create_offer_array(key_search_string)
        organizations |= create_orga_array(key_search_string)
      end
    end
    update_arrays offers, organizations
  end

  def create_offer_array key_search_string
    Offer.visible_in_frontend.where(
      'LOWER(description) ~ ?', key_search_string
    ).to_a
  end

  def create_orga_array key_search_string
    Organization.visible_in_frontend.where(
      'LOWER(description) ~ ?', key_search_string
    ).to_a
  end

  def update_arrays offers, organizations
    update_offers(offers)
    update_organizations(organizations)
  end

  def update_offers offers
    offers.each do |offer|
      infused_description = link_and_infuse_description(offer)
      old_infused_description = OfferTranslation.where(
        offer_id: offer.id, locale: 'de'
      ).first.description
      next unless infused_description != old_infused_description
      OfferTranslation.where(
        offer_id: offer.id, locale: 'de'
      ).first.update_attribute(:description, infused_description)
      offer.index!
    end
  end

  def update_organizations organizations
    organizations.each do |organization|
      old_infused_description = OrganizationTranslation.where(
        organization_id: organization.id, locale: 'de'
      ).first.description.to_s
      infused_description = link_and_infuse_description(organization)
      next unless infused_description != old_infused_description
      OrganizationTranslation.where(
        organization_id: organization.id, locale: 'de'
      ).first.update_attribute(:description, infused_description)
    end
  end

  def link_and_infuse_description object
    Definition::LinkAndInfuse.(
      {},
      'object_to_link' => object,
      'string_to_infuse' => MarkdownRenderer.render(
        object.untranslated_description
      ),
      'definition_positions' => []
    )['infused_description'].to_s
  end
end
