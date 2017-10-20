# frozen_string_literal: true

require_relative '../../test_helper'

describe API::V1::PossibleEventsController do
  let(:user) { users(:researcher) }

  it 'should respond to #show' do
    sign_in user
    get :show, params: { model: 'Organization', id: 1 }
    assert_response 200
  end
end
