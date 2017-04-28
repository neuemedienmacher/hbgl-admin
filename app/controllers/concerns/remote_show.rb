# frozen_string_literal: true
module RemoteShow
  def redirect_to_remote_show controller
    host = Rails.application.secrets.frontend_host
    section = section_for_model params
    identifier = section.nil? ? 'refugees' : section.identifier # for orga's without offers (no section)
    redirect_to "#{host}/#{identifier}/preview/#{controller}/#{params[:id]}"
  end

  private

  def section_for_model params
    klass = params[:controller].classify.constantize
    item = klass.where(slug: params[:id]).first
    klass == Offer ? item.section : item.sections.first
  end
end
