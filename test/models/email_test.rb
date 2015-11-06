require_relative '../test_helper'

describe Email do
  let(:email) { Email.new address: 'a@b.c' }
  subject { email }

  describe 'associations' do
    it { subject.must have_many :offer_mailings }
    it { subject.must have_many(:known_offers).through :offer_mailings }
  end

  describe 'methods' do
    it 'should find all newly approved offers for an email' do
      email = FactoryGirl.create :email, :with_approved_and_unapproved_offer
      email.not_yet_but_soon_known_offers.count.must_equal 1
    end
  end

  describe 'state machine' do
    describe '#inform' do
      subject { email.inform }

      describe 'when assigned to contact people with approved offers' do
        let(:email) { FactoryGirl.create :email, :with_approved_offer }

        it 'should be possible from uninformed' do
          OfferMailer.stub_chain(:inform, :deliver)
          subject.must_equal true
          email.must_be :informed?
        end

        it 'wont be possible if no organization is mailings_enabled' do
          email.organizations.update_all mailings_enabled: false
          OfferMailer.expects(:inform).never
          assert_raises(AASM::InvalidTransition) { subject }
        end

        it 'should transition to blocked when a contact_person is an SPoC and'\
           ' should not send email' do
          email.contact_people.first.update_column :spoc, true
          OfferMailer.expects(:inform).never
          subject
          email.must_be :blocked?
        end

        it 'should send an info email when transitioned' do
          OfferMailer.expect_chain(:inform, :deliver)
          subject
        end
      end

      describe 'when there are no approved offers' do
        let(:email) { FactoryGirl.create :email, :with_unapproved_offer }

        it 'should be impossible from uninformed and wont send an info mail' do
          OfferMailer.expects(:inform).never
          assert_raises(AASM::InvalidTransition) { subject }
        end
      end
    end
  end
end
