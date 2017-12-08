# frozen_string_literal: true

require_relative '../test_helper'

class ExpiringOffersWorkerTest < ActiveSupport::TestCase # to have fixtures
  let(:worker) { ExpiringOffersWorker.new }

  def set_expiration(date, other_options = {})
    other_options.merge updated_at: date - 1.year
  end

  it 'sends an email for offers that expire today, creates asana task, '\
     'unapproves them and calls manual index! to sync algolia' do
    today = Time.zone.today
    expiring =
      FactoryBot.create :offer, :approved, set_expiration(today - 1.day)
    later = FactoryBot.create :offer, :approved, set_expiration(today + 2.days)
    # Offer.any_instance.expects(:index!).once # no longer needed
    # OfferMailer.expect_chain(:expiring_mail, :deliver_now).once
    AsanaCommunicator.any_instance.expects(:create_expire_task).once
    worker.perform
    expiring.reload.must_be :expired?
    later.reload.must_be :approved?
    expiring.reload.visible_in_frontend?.must_equal true
    later.reload.visible_in_frontend?.must_equal true
  end

  it 'does not send an email, create asana task and call manual reindex for '\
     'offers that expired previously' do
    yesterday = Time.zone.now.beginning_of_day - 1
    Timecop.freeze(Time.zone.local(2015)) do
      FactoryBot.create :offer, set_expiration(yesterday)
    end
    # Offer.any_instance.expects(:index!).never
    # OfferMailer.expects(:expiring_mail).never
    AsanaCommunicator.any_instance.expects(:create_expire_task).never
    worker.perform
  end

  it 'does not send an email, create asana task and call manual reindex for '\
     'offers that will expire' do
    FactoryBot.create :offer, set_expiration(Time.zone.now.end_of_day + 1)
    # Offer.any_instance.expects(:index!).never
    # OfferMailer.expects(:expiring_mail).never
    AsanaCommunicator.any_instance.expects(:create_expire_task).never
    worker.perform
  end

  it 'should ignore seasonal offers - another worker does that' do
    today = Time.zone.today
    Timecop.freeze(today - 1.day)
    expiring =
      FactoryBot.create :offer, :approved,
                        set_expiration(today, starts_at: today - 30.days)
    Timecop.return
    Offer.any_instance.expects(:index!).never
    AsanaCommunicator.any_instance.expects(:create_expire_task).never
    worker.perform
    expiring.reload.must_be :approved?
  end
end
