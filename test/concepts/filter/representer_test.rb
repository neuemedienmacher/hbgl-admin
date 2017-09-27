# frozen_string_literal: true
require_relative '../../test_helper'

class API::V1::Filter::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::Filter::Representer::Show }

  it 'should provide its fields' do
    record = Filter.create! name: 'foo', identifier: 'free', type: 'TraitFilter'
    result = subject.new(record).to_hash
    result['data']['attributes']['label'].must_equal 'foo'
  end
end
