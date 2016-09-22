# frozen_string_literal: true
class BackendController < ApplicationController
  before_action :backend_setup

  def index
    render '/backend/index'
  end

  protected

  def process_params!(params)
    params.merge!(current_user: current_user)
  end

  private

  def backend_setup
    @klass_name = params['controller'].singularize.camelize
    @klass = @klass_name.constantize
    @settings = AdminConfig.settings[@klass_name]
  end
end
