# frozen_string_literal: true
require_relative '../../test_helper'

class API::V1::Assignment::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::Assignment::Representer::Show }

  it 'should provide its fields, the creator, and assignable' do
    record = Assignment.find(1)
    result = subject.new(record).to_hash
    result['data']['id'].must_equal '1'
    result['data']['attributes']['assignable_id'].must_equal 1
    result['data']['relationships']['creator']['data']['id'].must_equal '1'
    result['included'].first['type'].must_equal 'users'
    result['included'].first['id'].must_equal '1'
    result['data']['relationships']['assignable']['data']['id'].must_equal '1'
    result['included'].last['type'].must_equal 'assignable_type' # TODO: fix
    result['included'].last['id'].must_equal '1'
  end

  it 'should work with assignment for a non-translation model' do
    assignable = User.new(id: 99, created_at: Time.zone.now, name: 'foo')
    record = Assignment.new assignable: assignable
    result = subject.new(record).to_hash
    result['included'].first['attributes']['label'].must_equal 'foo'
  end

  it 'should generate a generic label for a model without a name' do
    assignable = NextStep.first
    record = Assignment.new assignable: assignable
    result = subject.new(record).to_hash
    result['included'].first['attributes']['label'].must_equal 'NextStep#1'
  end

  it 'contact person assignable test' do
    assignable = FactoryGirl.create :contact_person,
                                    responsibility: 'Geduld und Disziplin'
    record = Assignment.new assignable: assignable.translations.first
    result = subject.new(record).to_hash
    result['included'].first['attributes']['label'].must_equal 'Geduld und Disziplin'
  end
end
