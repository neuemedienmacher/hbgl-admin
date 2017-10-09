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

  it 'must create assignments with correct messages when called two times' do
    basic_options[:assignable] = FactoryGirl.create(:division)
    operation_must_work ::Assignment::CreateBySystem, {}, basic_options
    basic_options[:assignable].done = true
    result = operation_must_work ::Assignment::CreateBySystem, {}, basic_options
    assignment = result['model']
    assignment.message.must_equal 'Managed by system'
  end

  it 'must correctly use default logic for faked assignable' do
    result = operation_must_work ::Assignment::CreateBySystem, {}, basic_options
    assignment = result['model']
    assignment.must_be :persisted?
    basic_options[:assignable] =
      OpenStruct.new(id: 1, assignments: Assignment.where(id: assignment.id))
    result = operation_must_work ::Assignment::CreateBySystem, {}, basic_options
    assignment = result['model']
    assignment.creator_id.must_equal user.id
    assignment.receiver_id.must_equal user.id
    assignment.message.must_equal 'Assigned by system'
  end

  it 'must copy create errors if there are any' do
    errors = Reform::Form::ActiveModel::Errors.new foo: 'bar'
    errors.add :foo, 'baz'
    ::Assignment::Contracts::Create.any_instance.stubs(:errors).returns errors
    result = operation_wont_work ::Assignment::CreateBySystem, {}, basic_options
    refute_nil result['errors']
    result['errors'].messages.must_equal foo: ['baz']
  end

  # NOTE trying to create an invalid assignment.. not yet working
  # it 'wont work with a none-assignable model and add errors to options' do
  #   basic_options[:assignable] = users(:researcher)
  #   result = operation_wont_work ::Assignment::CreateBySystem, {}, basic_options
  #   result['errors'].any?.must_equal true
  # end

  # NOTE: more tests not really required because the logic is indirectly tested
  # by automatic_upsert_test
end
