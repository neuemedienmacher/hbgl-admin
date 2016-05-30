# frozen_string_literal: true
module API::V1
  class StatisticsController < ApplicationController
    skip_before_action :authenticate_user!
    respond_to :json

    def index
      respond API::V1::Statistic::Index
    end
  end
end
