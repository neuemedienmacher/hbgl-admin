# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class DivisionUpdateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:orga) { organizations(:basic) }
  let(:division) { FactoryGirl.create :division, organization: orga }
  let(:basic_params) do
    {
      id: division.id,
      addition: division.addition,
      city: orga.locations.first.city
    }
  end

  describe '::Division::Update' do
    it 'must create a Division given valid data' do
      operation_must_work ::Division::Update, basic_params, current_user: user
    end

    describe 'side-effects' do
      it 'wont do anything without the correct meta commit action' do
        basic_params['meta'] = { 'commit' => 'doesntexist' }
        operation_must_work ::Division::Update, basic_params, current_user: user
        division.reload.done.must_equal false
      end

      it 'set done to true and re-assign with the correct meta commit action' do
        basic_params['meta'] = { 'commit' => 'mark_as_done' }
        division.assignments.count.must_equal 1
        operation_must_work ::Division::Update, basic_params, current_user: user
        division.reload.done.must_equal true
        division.assignments.count.must_equal 2
      end

      it 'set done to false and resets orga to approved for mark_as_not_done' do
        basic_params['meta'] = { 'commit' => 'mark_as_not_done' }
        orga.aasm_state.must_equal 'all_done'
        operation_must_work ::Division::Update, basic_params, current_user: user
        division.reload.done.must_equal false
        orga.reload.aasm_state.must_equal 'approved'
      end

      it 're-assigns the organization to system when all divisions are done' do
        basic_params['meta'] = { 'commit' => 'mark_as_done' }
        # remove organization-connection from all other divisions
        Division.where(organization_id: division.organization_id)
                .where.not(id: division.id).update_all organization_id: nil
        organization = division.organization
        organization.update_columns aasm_state: 'approved'
        division.assignments.count.must_equal 1
        organization.assignments.count.must_equal 1
        operation_must_work ::Division::Update, basic_params, current_user: user
        division.reload.done.must_equal true
        division.assignments.count.must_equal 2
        organization.assignments.count.must_equal 2
        organization.reload.aasm_state.must_equal 'all_done'
      end
    end
  end
end
