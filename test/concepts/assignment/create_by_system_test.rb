# frozen_string_literal: true
require_relative '../../test_helper'

class AssignmentCreateBySystemTest < ActiveSupport::TestCase
  let(:user) { users(:researcher) }
  let(:basic_options) do
    { assignable: offer_translations(:en), last_acting_user: user }
  end

  it 'must create an assignment with inferred data' do
    result = ::Assignment::CreateBySystem.({}, basic_options)
    result.must_be :success?
    result['model'].must_be :persisted?
  end

  # it 'must create the correct assignment for' do
  #   result = ::Assignment::CreateBySystem.({}, basic_options)
  #   result.must_be :success?
  #   result['model'].must_be :persisted?
  # end

  # TODO: moar tests!
end
