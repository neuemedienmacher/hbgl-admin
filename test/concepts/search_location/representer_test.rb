# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::SearchLocation::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::SearchLocation::Representer::Show }
  let(:record) { search_locations(:berlin) }

  it 'should provide its fields' do
    result = subject.new(record).to_hash
    result['data']['attributes']['label'].must_equal 'Berlin'
  end
end
