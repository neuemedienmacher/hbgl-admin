# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::CategoriesController do
  include API::ControllerTestUtils
  let(:user) { users(:researcher) }
  before do
    sign_in user
  end

  it '#index should respond to jsonapi requests' do
    api_get_works_for :index
  end

  describe '#sort' do
    it '#sort should respond to api requests' do
      put :sort, categories: { 1 => { id: 1, children: {} } }
      assert_response 200
      response.body.must_include '{"status":"success"'
      response.body.must_include '"update_count":1'
    end
  end
end
