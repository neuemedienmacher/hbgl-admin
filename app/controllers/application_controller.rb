# frozen_string_literal: true
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Security by default
  before_action :authenticate_user!

  # Enable PaperTrail tracking
  before_action :set_paper_trail_whodunnit

  # HTTP password protection
  claradmin = Rails.application
  http_basic_authenticate_with(
    name: claradmin.secrets.protect['user'],
    password: claradmin.secrets.protect['pwd'],
    if: -> { Rails.env.staging? || Rails.env.production? }
  )

  # Trailblazer
  include Trailblazer::Operation::Controller

  # redirect to last page (e.g. open tab) or /admin after sign_in
  def after_sign_in_path_for(_resource)
    session['user_return_to'] || '/admin'
  end
end
