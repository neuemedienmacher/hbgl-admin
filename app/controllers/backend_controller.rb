class BackendController < ApplicationController
  before_action :backend_setup

  def index
    render '/backend/index'
  end

  private

  def backend_setup
    @klass_name = params['controller'].singularize.titleize
    @klass = @klass_name.constantize
    @settings = AdminConfig.settings[@klass_name]
  end
end