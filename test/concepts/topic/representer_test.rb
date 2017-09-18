# frozen_string_literal: true
require_relative '../../test_helper'

class API::V1::Topic::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::Topic::Representer::Show }
  let(:record) { Topic.create!(name: 'name') }

  it 'should provide its fields' do
    result = subject.new(record).to_hash
    result['data']['attributes']['label'].must_equal 'name'
  end
end
