# frozen_string_literal: true
require_relative '../../test_helper'

describe API::V1::FieldSetController do
  let(:user) { users(:researcher) }

  it 'should respond to #show' do
    sign_in user
    get :show, model: 'City'
    assert_response 200
  end
end
