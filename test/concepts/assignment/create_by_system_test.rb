# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class AssignmentCreateBySystemTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:basic_options) do
    { assignable: offer_translations(:en), last_acting_user: user }
  end
  # let(:faked_assignable) { OpenStruct.new( assignments: [] ) }

  it 'must create an assignment with inferred data' do
    operation_must_work ::Assignment::CreateBySystem, {}, basic_options
  end

  it 'must create the a system-assignment for a family-offer-translation' do
    result = operation_must_work ::Assignment::CreateBySystem, {}, basic_options
    assignment = result['model']
    assignment.must_be :persisted?
    assignment.receiver_id.must_equal User.system_user.id
    assert_nil assignment.receiver_team_id
    assignment.creator_id.must_equal User.system_user.id
    assert_nil assignment.creator_team_id
    assignment.message.must_equal 'Managed by system'
  end

  it 'must correctly use default logic for faked assignable' do
    basic_options[:assignable] = OpenStruct.new(id: 1, assignments: [])
    result = operation_must_work ::Assignment::CreateBySystem, {}, basic_options
    assignment = result['model']
    assignment.creator_id.must_equal user.id
    assignment.receiver_id.must_equal user.id
    assignment.message.must_equal 'New Assignment'
  end

  # NOTE: more tests not really required because the logic is indirectly tested
  # by automatic_upsert_test
end
