# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::Website::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::Website::Representer::Show }

  it 'should provide its fields' do
    result =
      subject.new(FactoryGirl.create(:website, url: 'https://foo.de')).to_hash
    assert result['data']['id'].is_a? String
    result['data']['attributes']['label'].must_equal 'https://foo.de'
    result['data']['attributes']['url'].must_equal 'https://foo.de'
  end
end
