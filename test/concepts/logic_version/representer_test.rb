# frozen_string_literal: true
require_relative '../../test_helper'

class API::V1::LogicVersion::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::LogicVersion::Representer::Show }
  let(:record) { LogicVersion.create!(name: 'testVersionName', version: 12) }

  it 'should provide its fields' do
    result = subject.new(record).to_hash
    result['data']['attributes']['label'].must_equal '12 - testVersionName'
  end
end
