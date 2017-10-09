# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::SplitBase::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::SplitBase::Representer::Show }
  let(:record) { split_bases(:basic) }

  it 'should provide its fields' do
    record.divisions << FactoryGirl.create(:division)
    result = subject.new(record).to_hash
    result['data']['attributes']['label'].must_equal 'basicSplitBaseTitle'
  end
end
