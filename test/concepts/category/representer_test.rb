# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::Category::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::Category::Representer::Create }

  it 'should provide its fields' do
    record = FactoryGirl.create :category, name_de: 'foo'
    record.children << FactoryGirl.create(:category, name_de: 'child', parent: record)
    result = subject.new(record).to_hash
    result['data']['attributes']['label'].must_equal 'foo (family,refugees)'
    result['included'].last['type'].must_equal 'categories'
    result['included'].last['attributes']['label'].must_equal 'child (family)'
  end
end
