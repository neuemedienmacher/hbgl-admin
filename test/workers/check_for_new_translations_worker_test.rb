# frozen_string_literal: true

require_relative '../test_helper'

class CheckForNewTranslationsWorkerTest < ActiveSupport::TestCase
  let(:worker) { CheckForNewTranslationsWorker.new }

  it 'should spawn for every existing (pending) GengoOrder' do
    order1 = GengoOrder.create! order_id: 23, expected_slug: 'Category:1:name'
    order2 = GengoOrder.create! order_id: 43, expected_slug: 'Category:2:name'
    GetAndApplyNewTranslationWorker.expects(:perform_async).with(order1.id)
    GetAndApplyNewTranslationWorker.expects(:perform_async).with(order2.id)
    worker.perform
  end
end
