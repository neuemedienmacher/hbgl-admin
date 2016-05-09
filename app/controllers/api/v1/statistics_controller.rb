# frozen_string_literal: true
module API::V1
  class StatisticsController < ApplicationController
    respond_to :json

    def index
      respond API::V1::Statistic::Index
    end
  end
end
