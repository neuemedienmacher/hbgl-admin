# frozen_string_literal: true
require_relative '../../test_helper'

class StatisticCountHandlerTest < ActiveSupport::TestCase # to have fixtures
  subject { Statistic::CountHandler }
  let(:user) { OpenStruct.new(id: 99) }

  describe '#record' do
    it 'must create a new statistic with the given data if none existed' do
      Statistic.count.must_equal 0
      subject.record user, 'Offer', 'aasm_state', 'initialized', 'completed'
      Statistic.count.must_equal 1
      stat = Statistic.last
      stat.trackable_id.must_equal 99
      stat.trackable_type.must_equal 'OpenStruct'
      stat.date.wont_be :nil?
      stat.model.must_equal 'Offer'
      stat.field_name.must_equal 'aasm_state'
      stat.field_start_value.must_equal 'initialized'
      stat.field_end_value.must_equal 'completed'
      stat.count.must_equal 1
    end

    it 'must modify an existing statistic if one exists' do
      stat = Statistic.create!(
        trackable_id: 99,
        trackable_type: 'OpenStruct',
        date: Time.zone.now.to_date,
        model: 'Offer',
        field_name: 'aasm_state',
        field_start_value: 'initialized',
        field_end_value: 'completed',
        count: 7
      )
      Statistic.count.must_equal 1
      subject.record user, 'Offer', 'aasm_state', 'initialized', 'completed'
      Statistic.count.must_equal 1
      stat.reload.count.must_equal 8
    end
  end
end
