# frozen_string_literal: true
class StatisticsController < ApplicationController
  def index
  end

  def show
    return raise 'unsafe' unless Statistic::TOPICS.include?(params['topic'])
    @topic = params['topic']
  end
end
