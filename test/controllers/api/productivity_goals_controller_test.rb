# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::ProductivityGoalsController do
  include API::ControllerTestUtils
  let(:user) { users(:researcher) }

  describe '#create' do
    let(:correct_params) do
      FactoryGirl.build(:productivity_goal).attributes
    end

    it 'should successfully handle a create request from super' do
      sign_in users(:super)
      create_works_with ProductivityGoal, correct_params
    end

    it 'should unauthenticate a request from normal researchers' do
      sign_in users(:researcher)
      create_fails_with ProductivityGoal, correct_params
    end
  end
end
