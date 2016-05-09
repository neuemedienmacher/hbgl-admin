# frozen_string_literal: true
class OrganizationsController < BackendController
  include RemoteShow

  def show
    redirect_to_remote_show :organisationen
  end
end
