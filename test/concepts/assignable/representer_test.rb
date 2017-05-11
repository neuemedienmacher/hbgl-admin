# frozen_string_literal: true
require_relative '../../test_helper'

class API::V1::Assignable::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::Assignable::Representer::Show }

  it 'should provide the current_assignment and the assignments collection' do
    record = OfferTranslation.find(1)
    result = subject.new(record).to_hash
    result['data']['id'].must_equal '1'
    result['data']['attributes']['current_assignment'].must_equal Assignment.first
    result['data']['relationships']['assignments'].length.must_equal 1
  end
end
