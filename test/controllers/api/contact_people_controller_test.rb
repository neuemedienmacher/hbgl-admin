# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::ContactPeopleController do
  include API::ControllerTestUtils
  before { sign_in users(:researcher) }
  let(:contact_person) { FactoryGirl.create(:contact_person) }

  it { api_get_works_for :index }
  it { api_get_works_for :show, id: contact_person.id }

  let(:create_params) { { first_name: 'foo', rel: { organization: 1 } } }
  it { create_works_with ::ContactPerson, create_params }
  it { update_works_with ::ContactPerson, contact_person.id, first_name: 'Ed' }

  it { has_no_route_for :delete, :destroy }
end
