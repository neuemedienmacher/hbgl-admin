# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::LanguageFilter::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::LanguageFilter::Representer::Show }

  it 'should provide its fields' do
    record = LanguageFilter.first
    result = subject.new(record).to_hash
    result['data']['attributes']['label'].must_equal 'Deutsch'
  end
end
