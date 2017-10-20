# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::Subscription::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::Subscription::Representer::Show }
  let(:record) { Subscription.create!(email: 'a@a.com') }

  it 'should provide its fields' do
    result = subject.new(record).to_hash
    result['data']['attributes']['label'].must_equal 'a@a.com'
  end
end
