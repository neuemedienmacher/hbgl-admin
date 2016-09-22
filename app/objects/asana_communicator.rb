# frozen_string_literal: true
class AsanaCommunicator < NetCommunicator
  WORKSPACE = '41140436022602'
  PROJECTS = { expired: %w(44856824806357), ricochet: %w(147663824592112),
               big_orga_without_mailing: %w(85803884880432) }.freeze

  def initialize
    super 'https://app.asana.com'
    @token = Rails.application.secrets.asana_token
  end

  def create_expire_task offer
    organization_names = offer.organizations.pluck(:name).join(',')
    section_names =
      offer.section_filters.pluck(:identifier).map { |f| f.first(3) }.join(',')
    create_task(
      "#{organization_names} - #{offer.expires_at} - #{section_names}"\
      " - #{offer.name}",
      "Expired: http://claradmin.herokuapp.com/admin/offer/#{offer.id}/edit"
    )
  end

  def create_website_unreachable_task_offer website, offer
    orgas = offer.organizations.pluck(:name).join(',')
    worlds = offer.section_filters.pluck(:identifier).join(',')
    create_task(
      "[Offer website unreachable] #{worlds} | Version:"\
      " #{offer.logic_version.version} | #{orgas} | #{offer.name}",
      'Deactivated: http://claradmin.herokuapp.com/admin/offer/'\
      "#{offer.id}/edit | Unreachable website: #{website.url}",
      :ricochet
    )
  end

  def create_website_unreachable_task_orgas website
    organization_names = website.organizations.approved.pluck(:name).join(',')
    create_task "[Orga-website unreachable] #{organization_names}",
                "Unreachable website: #{website.url}", :ricochet
  end

  def create_seasonal_offer_ready_for_checkup_task offer
    organization_names = offer.organizations.pluck(:name).join(',')
    create_task "WV | Saisonales Angebot | Start date: #{offer.starts_at} | "\
                "#{organization_names} | #{offer.name}",
                "http://claradmin.herokuapp.com/admin/offer/#{offer.id}/edit",
                :ricochet
  end

  # rubocop:disable Metrics/AbcSize
  def create_big_orga_is_done_task orga
    base_link = 'http://claradmin.herokuapp.com/admin'
    content = "#{base_link}/organization/#{orga.id}/edit"
    # first position contact (if any)
    contacts = orga.contact_people.where.not(position: nil)
    if contacts.any?
      content += " | Position-Kontakt: #{base_link}/contact_person/"\
                 "#{contacts.first.id}/edit"
    end
    # homepage
    content += " | Website: #{base_link}/website/#{orga.homepage.id}/edit"
    create_task "#{orga.section_filters.pluck(:identifier).uniq.join(', ')} | "\
                "#{orga.name}", content, :big_orga_without_mailing
  end
  # rubocop:enable Metrics/AbcSize

  protected

  def modify_request request
    request['Authorization'] = "Bearer #{@token}"
    request
  end

  private

  def create_task title, content, project_identifier = :expired
    post_to_api(
      '/api/1.0/tasks',
      projects: PROJECTS[project_identifier], workspace: WORKSPACE,
      name: title, notes: content
    )
  end
end
