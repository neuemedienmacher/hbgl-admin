# frozen_string_literal: true
class StatisticsController < ApplicationController
  def index
    secrets = Rails.application.secrets
    @props = {
      ajaxAuth: secrets.protect['user'] + ':' + secrets.protect['pwd']
    }
  end
end
