# frozen_string_literal: true
require_relative '../../test_helper'

class API::V1::UpdateRequest::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::UpdateRequest::Representer::Show }
  let(:record) { UpdateRequest.create!(email: 'a@a.com', search_location: 'b') }

  it 'should provide its fields' do
    result = subject.new(record).to_hash
    result['data']['attributes']['label'].must_equal 'a@a.com'
  end
end
