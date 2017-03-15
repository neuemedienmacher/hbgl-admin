# frozen_string_literal: true
class OrganizationsController < ApplicationController
  include RemoteShow

  def show
    redirect_to_remote_show :organisationen
  end
end
