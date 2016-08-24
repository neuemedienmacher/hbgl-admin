# frozen_string_literal: true
require 'net/http'
require 'uri'

class AsanaCommunicator
  WORKSPACE = '41140436022602'
  PROJECTS = { expired: %w(44856824806357), seasonal: %w(147663824592112),
               big_orga_without_mailing: %w(85803884880432) }.freeze

  def initialize
    @token = Rails.application.secrets.asana_token
  end

  def create_expire_task offer
    organization_names = offer.organizations.pluck(:name).join(',')
    section_names = offer.section_filters.pluck(:identifier).map { |f| f.first(3) }
                         .join(',')
    create_task "#{organization_names} - #{offer.expires_at} - #{section_names}"\
                " - #{offer.name}",
                'Expired: http://claradmin.herokuapp.com/admin/offer/'\
                "#{offer.id}/edit"
  end

  def create_website_unreachable_task_offer website, offer
    orgas = offer.organizations.pluck(:name).join(',')
    worlds = offer.section_filters.pluck(:identifier).join(',')
    create_task "[Offer-website unreachable] #{worlds} | Version: "\
                "#{offer.logic_version.version} | #{orgas} | #{offer.name}",
                'Deactivated: http://claradmin.herokuapp.com/admin/offer/'\
                "#{offer.id}/edit | Unreachable website: #{website.url}"
  end

  def create_website_unreachable_task_orgas website
    organization_names = website.organizations.approved.pluck(:name).join(',')
    create_task "[Orga-website unreachable] #{organization_names}",
                "Unreachable website: #{website.url}"
  end

  def create_seasonal_offer_ready_for_checkup_task offer
    organization_names = offer.organizations.pluck(:name).join(',')
    create_task "WV | Saisonales Angebot | Start date: #{offer.starts_at} | "\
                "#{organization_names} | #{offer.name}",
                "http://claradmin.herokuapp.com/admin/offer/#{offer.id}/edit",
                :seasonal
  end

  def create_big_orga_is_done_task orga
    base_link = 'http://claradmin.herokuapp.com/admin'
    content = "#{base_link}/organization/#{orga.id}/edit"
    # first position contact (if any)
    contacts = orga.contact_people.where.not(position: nil)
    content += " | Position-Kontakt: #{base_link}/contact_person/"\
               "#{contacts.first.id}/edit" if contacts.any?
    # homepage
    content += " | Website: #{base_link}/website/#{orga.homepage.id}/edit"
    create_task "#{orga.section_filters.pluck(:identifier).join(', ')} | "\
                "#{orga.name}", content, :big_orga_without_mailing
  end

  private

  def create_task title, content, project_identifier = :expired
    post_to_api(
      '/tasks',
      projects: PROJECTS[project_identifier], workspace: WORKSPACE,
      name: title, notes: content
    )
  end

  def post_to_api endpoint, form_hash
    request = Net::HTTP::Post.new("/api/1.0#{endpoint}")
    request.set_form_data form_hash
    request['Authorization'] = "Bearer #{@token}"
    send_request_to_api request
  end

  def send_request_to_api request
    uri = URI.parse('https://app.asana.com')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.request(request)
  end
end
