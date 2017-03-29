# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class UserTeamUpdateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:super) }
  let(:basic_params) do
    {
      id: 1,
      name: 'UserTeamName',
      user_ids: [1]
    }
  end

  describe '::UserTeam::Update' do
    it 'must create a UserTeam given valid data' do
      operation_must_work ::UserTeam::Update, basic_params
    end

    describe 'validations' do
      it 'must validate name' do
        basic_params[:name] = nil
        operation_wont_work ::UserTeam::Update, basic_params
      end

      it 'must validate user_ids' do
        basic_params[:user_ids] = nil
        operation_wont_work ::UserTeam::Update, basic_params
        basic_params[:user_ids] = []
        operation_wont_work ::UserTeam::Update, basic_params
        basic_params[:user_ids] = [1, 2]
        operation_must_work ::UserTeam::Update, basic_params
      end
    end
  end
end
