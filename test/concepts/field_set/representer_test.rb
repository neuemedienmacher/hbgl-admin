# frozen_string_literal: true
require_relative '../../test_helper'

class API::V1::FieldSet::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::FieldSet::Show }

  it 'should ignore the polymorphic association of assignments' do
    result = subject.new(Assignment).to_hash
    assert_nil result['associations'][:assignable]
  end

  it 'should correctly process the class_name' do
    result = subject.new(User).to_hash
    result['associations'][:created_assignments]['class_name'].must_equal 'assignments'
  end

  it 'should provide the correct key for a given class name' do
    result = subject.new(User).to_hash
    result['associations'][:created_assignments]['key'].must_equal 'creator_id'
  end
end
