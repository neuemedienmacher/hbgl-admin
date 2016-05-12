# frozen_string_literal: true
class Backend::HeaderCell < Cell::Concept
  def show
    render
  end

  private

  def dashboard_link
    link_to 'Dashboard', root_path
  end

  def statistics_link
    link_to 'Statistics', statistics_path
  end

  def sidekiq_link
    link_to 'Sidekiq', '/sidekiq'
  end

  def old_backend_link
    link_to 'Altes Backend', '/admin'
  end

  def logout_link(&block)
    link_to destroy_user_session_path, { method: :delete }, &block
  end
end
