# frozen_string_literal: true

require_relative '../test_helper'

class ViewingChannelTest < ActionCable::Channel::TestCase
  before do
    ViewingChannel.any_instance.stubs(:current_user).returns users(:researcher)
  end

  it 'should track the number of subscribing views and return them' do
    assert_broadcasts 'viewing:offers:1', 0
    subscribe model: 'offers', id: 1, view: 'show', sessionID: 'foo'
    assert_broadcasts 'viewing:offers:1', 1
    broadcasts('viewing:offers:1').last.must_equal(
      '{"model":"offers","id":"1","views":{"show":["1"]}}'
    )

    # second tab gets opened on same view
    subscribe model: 'offers', id: 1, view: 'show', sessionID: 'bar'
    broadcasts('viewing:offers:1').last.must_equal(
      '{"model":"offers","id":"1","views":{"show":["1","1"]}}'
    )

    # one tab changes view internally
    perform :change_view,
            'model' => 'offers', 'id' => 1, 'view' => 'edit',
            'sessionID' => 'foo'
    broadcasts('viewing:offers:1').last.must_equal(
      '{"model":"offers","id":"1","views":{"edit":["1"],"show":["1"]}}'
    )

    # changes view externally (from one model instance to another)
    assert_broadcasts 'viewing:cities:2', 0
    perform :change_view,
            'model' => 'cities', 'id' => 2, 'view' => 'show',
            'sessionID' => 'foo'
    broadcasts('viewing:offers:1').last.must_equal(
      '{"model":"offers","id":"1","views":{"edit":[],"show":["1"]}}'
    )
    broadcasts('viewing:cities:2').last.must_equal(
      '{"model":"cities","id":"2","views":{"edit":[],"show":["1"]}}'
    )

    # show tab gets closed
    subscription.unsubscribe_from_channel
    broadcasts('viewing:offers:1').last.must_equal(
      '{"model":"offers","id":"1","views":{"edit":[],"show":[]}}'
    )
    broadcasts('viewing:cities:2').last.must_equal(
      '{"model":"cities","id":"2","views":{"edit":[],"show":["1"]}}'
    )
  end

  it "should throw an error when some requested data doesn't exist on redis" do
    assert_raise(ViewingChannel::ViewingMemory::NoRedisDataError) do
      ViewingChannel::ViewingMemory.get_current('view', 'keynotfound')
    end
  end
end
