class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Security by default
  before_action :authenticate_user!

  # HTTP password protection
  claradmin = Rails.application
  http_basic_authenticate_with(
    name: claradmin.secrets.protect['user'],
    password: claradmin.secrets.protect['pwd'],
    if: -> { Rails.env.staging? || Rails.env.production? }
  )

  # Trailblazer
  include Trailblazer::Operation::Controller
end
