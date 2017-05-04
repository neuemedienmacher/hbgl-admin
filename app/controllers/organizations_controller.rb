# frozen_string_literal: true
class OrganizationsController < ApplicationController
  include RemoteShow

  def show
    section = Organization.find(params[:id]).sections.first
    identifier = section.nil? ? 'refugees' : section.identifier
    redirect_to_remote_show :organisationen, identifier
  end
end
