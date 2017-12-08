# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::City::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::City::Representer::Create }
  let(:record) { cities(:basic) }

  it 'should provide its fields' do
    record.divisions << FactoryBot.create(:division)
    result = subject.new(record).to_hash
    result['data']['attributes']['label'].must_equal 'Berlin'
  end
end
