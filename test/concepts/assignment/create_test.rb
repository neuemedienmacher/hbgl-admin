# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
require_relative '../../support/utils/jsonapi_test_utils'

class AssignmentCreateTest < ActiveSupport::TestCase
  include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:other_user) { users(:super) }
  let(:basic_params) do
    {
      assignable_id: 1,
      assignable_type: 'OfferTranslation',
      creator_id: user.id,
      receiver_id: users(:super).id
    }
  end

  describe '::Assignment::Create' do
    it 'must create an assignment given valid data' do
      operation_must_work ::Assignment::Create, basic_params
    end

    describe 'validations' do
      it 'must validate assignable_id' do
        basic_params[:assignable_id] = nil
        operation_wont_work ::Assignment::Create, basic_params
      end

      it 'must validate assignable_type' do
        basic_params[:assignable_type] = nil
        operation_wont_work ::Assignment::Create, basic_params
      end

      it 'must validate receiver_id if receiver_team_id is nil' do
        basic_params[:receiver_team_id] = nil
        operation_must_work ::Assignment::Create, basic_params
        basic_params[:receiver_id] = nil
        operation_wont_work ::Assignment::Create, basic_params
      end

      it 'must validate receiver_team_id if receiver_id is nil' do
        basic_params[:receiver_id] = nil
        basic_params[:receiver_team_id] = 1
        operation_must_work ::Assignment::Create, basic_params
        basic_params[:receiver_team_id] = nil
        operation_wont_work ::Assignment::Create, basic_params
      end
    end

    describe 'methods' do
      it 'must set current_user to creator if empty' do
        basic_params[:creator_id] = nil
        result = operation_must_work ::Assignment::Create, basic_params, current_user: other_user
        result['model'].creator_id.must_equal other_user.id
      end

      describe 'close_open_assignments!' do
        it 'must close all open assignments and create a new one' do
          assignments =
            OfferTranslation.find(basic_params[:assignable_id]).assignments
          count_before = assignments.count
          assignments.open.count.must_equal 1
          assignment_before = assignments.open.first
          operation_must_work ::Assignment::Create, basic_params
          assignment_before.reload.aasm_state.must_equal 'closed'
          assignments.count.must_equal count_before + 1
          assignments.open.first.wont_equal assignment_before
        end
      end

      describe 'reset_translation_if_returned_to_system_user' do
        it 'resets translation when system_user is assigned by other user' do
          t = OfferTranslation.find(basic_params[:assignable_id])
          t.update_columns source: 'GoogleTranslate', possibly_outdated: true
          basic_params[:receiver_id] = User.system_user.id
          basic_params[:created_by_system] = false
          operation_must_work ::Assignment::Create, basic_params
          t.reload.source.must_equal 'researcher'
          t.reload.possibly_outdated.must_equal false
        end

        it 'does not reset translation if created_by_system is true' do
          t = OfferTranslation.find(basic_params[:assignable_id])
          t.update_columns source: 'GoogleTranslate', possibly_outdated: true
          basic_params[:receiver_id] = User.system_user.id
          basic_params[:created_by_system] = true
          operation_must_work ::Assignment::Create, basic_params
          t.reload.source.must_equal 'GoogleTranslate'
          t.reload.possibly_outdated.must_equal true
        end

        it 'does not reset translation if someone else is assigned' do
          t = OfferTranslation.find(basic_params[:assignable_id])
          t.update_columns source: 'GoogleTranslate', possibly_outdated: true
          basic_params[:created_by_system] = false
          operation_must_work ::Assignment::Create, basic_params
          t.reload.source.must_equal 'GoogleTranslate'
          t.reload.possibly_outdated.must_equal true
        end
      end
    end
  end

  describe 'API::V1::Assignment::Create' do
    it 'wont create an assignment from a pure param hash' do
      api_operation_wont_work(API::V1::Assignment::Create, basic_params.to_json)
    end

    it 'must create an assignment from a JSONAPI document' do
      api_operation_must_work(
        API::V1::Assignment::Create, to_jsonapi(basic_params, 'assignments')
      )
    end
  end
end
