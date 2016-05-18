# frozen_string_literal: true
require_relative '../test_helper'

class UninformedEmailMailingWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures
  let(:worker) { UninformedEmailMailingWorker.new }

  it 'calls #inform! on the given email' do
    email = FactoryGirl.create :email, :uninformed, :with_approved_offer
    Email.any_instance.expects(:inform!).once
    worker.perform email.id
  end
end
