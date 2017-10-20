# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::Division::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::Division::Representer::Create }

  it 'should provide its fields' do
    record = FactoryGirl.create :division,
                                addition: 'foo',
                                organization: Organization.find(1)
    result = subject.new(record).to_hash
    result['data']['attributes']['label'].must_equal('default division label')
    result['data']['relationships']['organization']['data']['id'].must_equal '1'
  end
end
