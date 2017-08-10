# frozen_string_literal: true
require_relative '../../test_helper'

class AssignableCommonSideEffectsTest < ActiveSupport::TestCase
  let(:subject) do
    Class.new { include Assignable::CommonSideEffects::CreateNewAssignment }
  end
  let(:user) { users(:researcher) }
  let(:options) do
    { 'params' => { 'meta' => { 'commit' => 'closeAssignment' } } }
  end
  let(:model_user) do
    { model: offer_translations(:en), current_user: user }
  end

  it 'create_new_assignment_if_save_and_close_clicked should succeed' do
    result = subject.new.create_new_assignment_if_save_and_close_clicked!(options, model_user)
    result.must_equal true
  end
end
