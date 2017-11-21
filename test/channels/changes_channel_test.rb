# frozen_string_literal: true

require_relative '../test_helper'

class ChangesChannelTest < ActionCable::Channel::TestCase
  before do
    ChangesChannel.any_instance.stubs(:current_user).returns users(:researcher)
  end

  it 'streams from "changes"' do
    assert_broadcasts 'changes', 0
    subscribe
    ActionCable.server.broadcast('changes', 'foo')
    assert_broadcasts 'changes', 1
  end
end
