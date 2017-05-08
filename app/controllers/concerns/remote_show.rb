# frozen_string_literal: true
module RemoteShow
  def redirect_to_remote_show controller, identifier
    host = Rails.application.secrets.frontend_host
    item = model_instance params
    redirect_to "#{host}/#{identifier}/preview/#{controller}/#{item.slug}"
  end

  private

  def model_instance params
    klass = params[:controller].classify.constantize
    klass.find(params[:id])
  end
end
