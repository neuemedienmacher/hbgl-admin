# frozen_string_literal: true
require_relative '../../test_helper'

class API::V1::Website::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::Website::Representer::Show }

  it 'should provide its fields' do
    result =
      subject.new(FactoryGirl.create(:website, url: 'https://foo.de')).to_hash
    result['data']['id'].must_equal '2'
    result['data']['attributes']['label'].must_equal 'https://foo.de'
    result['data']['attributes']['url'].must_equal 'https://foo.de'
  end
end
