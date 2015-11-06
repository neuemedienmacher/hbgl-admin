require_relative '../test_helper'

class EmailPusherWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures
  let(:worker) { EmailPusherWorker.new }

  describe 'perform' do
    it 'should call Ribbon API' do
      subscription = FactoryGirl.create :subscription
      Gibbon::API.any_instance.expect_chain(:lists, :subscribe).once
      worker.perform subscription.id
    end
  end
end
