# frozen_string_literal: true

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
      email = FactoryBot.create :email, :with_approved_and_unapproved_offer
      email.newly_approved_offers_from_offer_context.count.must_equal 1
    end

    it 'shoul corretly use search_pg' do
      result = Email.search_pg('test')
      result.count.must_equal 1
    end

    describe '#informable_offers?' do
      it 'should be true if it has approved offers & a mailings=enabled orga' do
        email = FactoryBot.create :email
        offer = FactoryBot.create :offer, :approved
        offer.contact_people.first.update_column :email_id, email.id
        email.organizations.first.update_column :mailings, 'enabled'
        email.send(:informable_offers?).must_equal true
      end

      it 'should be false if it has no approved offers' do
        email = FactoryBot.create :email
        offer = FactoryBot.create :offer
        offer.contact_people.first.update_column :email_id, email.id
        email.organizations.first.update_column :mailings, 'enabled'
        email.send(:informable_offers?).must_equal false
      end

      it 'should be false if it has no mailings=enabled orga' do
        email = FactoryBot.create :email
        offer = FactoryBot.create :offer, :approved
        offer.contact_people.first.update_column :email_id, email.id
        email.organizations.first.update_column :mailings, 'force_disabled'
        email.send(:informable_offers?).must_equal false
      end
    end
  end

  # moved from _base - now in contracts
  # describe 'validations' do
  #   describe 'always' do
  #     it { subject.must validate_presence_of :address }
  #     it { subject.must validate_uniqueness_of :address }
  #     it { subject.must validate_length_of(:address).is_at_most 64 }
  #     it { subject.must validate_length_of(:address).is_at_least 3 }
  #
  #     it 'does not allow whitespaces in address (possible duplicates)' do
  #       duplicate_mail = Email.new address: ' a@b.c'
  #       duplicate_mail.valid?.must_equal false
  #     end
  #   end
  #
  #   describe 'on update' do
  #     let(:email) { Email.create! address: 'a@b.c' }
  #     it { subject.must validate_presence_of :security_code }
  #
  #     it 'does not need a security_code in blocked state' do
  #       subject.aasm_state = 'blocked'
  #       subject.security_code.must_be :nil?
  #       subject.valid?.must_equal true
  #     end
  #   end
  # end

  describe 'state machine' do
    describe '#inform' do
      subject { email.inform }

      describe 'when assigned to contact people with approved offers' do
        let(:email) { FactoryBot.create :email, :with_approved_offer }

        it 'should be possible from uninformed' do
          OfferMailer.expect_chain(:inform_offer_context, :deliver_now)
          subject.must_equal true
          email.must_be :informed?
        end

        it 'wont be possible from informed' do
          email.aasm_state = 'informed'
          assert_raises(AASM::InvalidTransition) { subject }
        end

        it 'wont be possible from subscribed' do
          email.aasm_state = 'subscribed'
          assert_raises(AASM::InvalidTransition) { subject }
        end

        it 'wont be possible from unsubscribed' do
          email.aasm_state = 'unsubscribed'
          assert_raises(AASM::InvalidTransition) { subject }
        end

        it 'wont be possible if no organization is mailings=disabled' do
          email.organizations.update_all mailings: 'force_disabled'
          OfferMailer.expects(:inform_offer_context).never
          assert_raises(AASM::InvalidTransition) { subject }
        end

        it 'should transition to blocked when a contact_person is an SPoC and'\
           ' should not send email' do
          email.contact_people.first.update_column :spoc, true
          OfferMailer.expects(:inform_offer_context).never
          subject
          email.must_be :blocked?
        end

        it 'should send an info email when transitioned' do
          OfferMailer.expect_chain(:inform_offer_context, :deliver_now)
          subject
        end
      end

      describe 'when there are no approved offers' do
        let(:email) { FactoryBot.create :email, :with_unapproved_offer }

        it 'should be impossible from uninformed and wont send an info mail' do
          OfferMailer.expects(:inform_offer_context).never
          assert_raises(AASM::InvalidTransition) { subject }
        end
      end
    end

    describe '#send_mailings!' do
      it 'should generate a security code' do
        email.expects(:regenerate_security_code)
        email.stubs(:raise)
        email.send_mailing!
      end

      it 'should send an offer context mailing when it has approved offers'\
         ' and is in a mailings=enabled organization' do
        email = FactoryBot.create :email, :with_approved_offer
        email.organizations.first.update_column :mailings, 'enabled'
        OfferMailer.expect_chain(:inform_offer_context, :deliver_now)
        email.send_mailing!
      end

      it 'should send an orga context mailing when it is an orga contact'\
         ', when orga is mailings=enabled and has approved offers' do
        email = FactoryBot.create :email, :with_approved_offer
        email.organizations.first.update_column :mailings, 'enabled'
        superior_mail = FactoryBot.create :email
        superior_mail.contact_people <<
          FactoryBot.create(
            :contact_person,
            organization: email.organizations.first,
            position: 'superior',
            email: superior_mail
          )

        OfferMailer.expect_chain(:inform_organization_context, :deliver_now)
        superior_mail.send_mailing!
      end

      it 'should send an offer context mailing even when the contact qualifies'\
         ' for an orga-mailing (higher priority on offer-mailings)' do
        mail = FactoryBot.create :email, :with_approved_offer
        mail.contact_people.first.update_column :position, 'superior'
        mail.organizations.first.update_column :mailings, 'enabled'
        # mail.contact_people.first.organization = mail.organizations.first
        # # mail.organizations.first.offers = mail.offers

        mail.belongs_to_unique_orga_with_orga_contact?.must_equal true
        OfferMailer.expect_chain(:inform_offer_context, :deliver_now)
        OfferMailer.expects(:inform_organization_context).never
        mail.send_mailing!
      end

      it 'should raise an error when neither of the above is true' do
        assert_raises(RuntimeError) { email.send_mailing! }
      end

      it 'wont send an offer context mailing when it has approved offers'\
         ' but the orga is not mailings=enabled' do
        email = FactoryBot.create :email, :with_approved_offer
        email.organizations.first.update_column :mailings, 'force_disabled'
        OfferMailer.expects(:inform_offer_context).never
        assert_raises { email.send_mailing! }
      end

      it 'wont send an offer context mailing when it has no approved offers'\
         ' but the orga is mailings=enabled' do
        email = FactoryBot.create :email, :with_unapproved_offer
        email.organizations.first.update_column :mailings, 'enabled'
        OfferMailer.expects(:inform_offer_context).never
        assert_raises { email.send_mailing! }
      end

      it 'wont send an orga context mailing when it is in a position contact'\
         ' but is in more than one organization' do
        email = FactoryBot.create :email, :with_unapproved_offer
        email.contact_people.first.update_column :position, 'superior'
        email.contact_people <<
          FactoryBot.create(:contact_person, position: 'superior')
        OfferMailer.expects(:inform_organization_context).never
        assert_raises { email.send_mailing! }
      end
    end
  end
end
