module RemoteShow
  def redirect_to_remote_show controller
    host = Rails.application.secrets.frontend_host
    redirect_to "#{host}/#{controller}/#{params[:id]}"
  end
end
