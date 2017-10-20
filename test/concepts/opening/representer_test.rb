# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::Opening::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::Opening::Representer::Show }

  it 'should provide its fields' do
    record = Opening.create!(day: 'mon', open: '00:00', close: '00:01',
                             name: 'x', sort_value: 12)
    result = subject.new(record).to_hash
    result['data']['attributes']['open'].must_equal '00:00'
    result['data']['attributes']['close'].must_equal '00:01'
  end
end
