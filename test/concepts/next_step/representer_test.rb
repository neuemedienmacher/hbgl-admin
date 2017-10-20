# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::NextStep::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::NextStep::Representer::Show }
  let(:record) { NextStep.create!(text_de: 'textDe', text_en: 'textEn') }

  it 'should provide its fields' do
    result = subject.new(record).to_hash
    result['data']['attributes']['label'].must_equal 'textDe'
  end
end
