# frozen_string_literal: true

class AsanaCommunicator < NetCommunicator
  WORKSPACE = '41140436022602'
  PROJECTS = { expired: %w[44856824806357], ricochet: %w[147663824592112],
               big_orga_without_mailing: %w[85803884880432] }.freeze

  def initialize
    super 'https://app.asana.com'
    @token = Rails.application.secrets.asana_token
  end

  def create_expire_task offer
    organization_names = offer.organizations.order(:id).pluck(:name).join(',')
    section_name =
      offer.section.identifier.first(3)
    create_task(
      "#{organization_names} - #{offer.expires_at} - #{section_name}"\
      " - #{offer.name}",
      "Expired: http://claradmin.herokuapp.com/offers/#{offer.id}/edit"
    )
  end

  def create_seasonal_offer_ready_for_checkup_task offer
    organization_names = offer.organizations.pluck(:name).join(',')
    create_task "WV | Saisonales Angebot | Start date: #{offer.starts_at} | "\
                "#{organization_names} | #{offer.name}",
                "http://claradmin.herokuapp.com/offers/#{offer.id}/edit",
                :ricochet
  end

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
