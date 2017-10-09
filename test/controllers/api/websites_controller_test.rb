# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::WebsitesController do
  include API::ControllerTestUtils
  before { sign_in users(:researcher) }

  it { api_get_works_for :index }
  it { create_works_with Website, host: 'own', url: 'http://foo.com' }

  it { has_no_route_for :get, :show }
  it { has_no_route_for :patch, :update }
  it { has_no_route_for :delete, :destroy }
end
