# frozen_string_literal: true
require_relative '../test_helper'
class GeocodingWorkerWorkerTest < ActiveSupport::TestCase # to have fixtures
  let(:subject) { GeocodingWorker.new }

  it 'should work for a basic location and return stubbed long/lat values' do
    location = locations(:basic)
    subject.perform location.id
    location.reload.longitude.must_equal 20.0
    location.reload.latitude.must_equal 10.0
  end

  it 'should raise an exception for non-existing cities' do
    location = locations(:basic)
    Location.any_instance.stubs(:_alt_addr).returns('Bielefeld')
    assert_raises(RuntimeError) { subject.perform location.id }
  end
end
