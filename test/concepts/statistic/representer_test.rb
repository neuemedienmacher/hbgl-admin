# frozen_string_literal: true
require_relative '../../test_helper'

class API::V1::Statistic::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::Statistic::Representer::Show }

  it 'should provide its fields, the creator, and assignable' do
    record = Statistic.create!(
      trackable_id: User.first.id, trackable_type: 'User', count: 1,
      time_frame: 'daily', date: Date.current
    )
    result = subject.new(record).to_hash
    result[:data][:id].must_equal '1'
    result[:data][:attributes]['trackable_id'].must_equal 1
    result[:data][:relationships]['trackable'][:data][:id].must_equal '1'
    result[:included].first[:type].must_equal 'trackable_type' # TODO: fix
    result[:included].first[:id].must_equal '1'
  end

  it 'should generate a generic label for a model without a name' do
    record = Statistic.create!(
      trackable_id: User.first.id, trackable_type: 'User', count: 1,
      time_frame: 'daily', date: Date.current
    )
    result = subject.new(record).to_hash
    result[:included].first[:attributes]['label'].must_equal 'User#1'
  end
end
