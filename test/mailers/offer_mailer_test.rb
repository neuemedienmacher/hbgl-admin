# frozen_string_literal: true
require_relative '../test_helper'

describe OfferMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:offer) do
    FactoryGirl.create(:offer, :approved)
  end
  let(:contact_person) do
    FactoryGirl.create(:contact_person,
                       { email: email, offers: [offer] }.merge(options))
  end
  let(:options) { {} }

  # describe '#expiring_mail' do
  #   it 'must deliver' do
  #     mail = OfferMailer.expiring_mail 1, [offer.id]
  #     mail.must deliver_from 'post@clarat.org'
  #     mail.must have_body_text '1 offer expired today:'
  #     mail.must have_body_text offer.id.to_s
  #   end
  # end

  describe '#inform_offer_context' do
    let(:email) do
      FactoryGirl.create :email, :with_security_code, address: 'foo@bar.baz'
    end

    subject { OfferMailer.inform_offer_context email }
    before { contact_person }

    it 'must deliver and create offer_mailings with x-smtpapi header' do
      email.expects(:create_offer_mailings)
      subject.header['X-SMTPAPI'].value.must_include 'inform offer'
      subject.header['X-SMTPAPI'].value.must_include offer.section.identifier
      subject.must deliver_to 'foo@bar.baz'
      subject.must have_body_text 'clarat'
      subject.must have_body_text '/subscribe'
      subject.must have_body_text email.security_code
    end

    it 'only informs about offers by mailings=enabled organizations' do
      offer2 = FactoryGirl.create :offer, :approved,
                                  name: 'By mailings=enabled organization'
      offer2.contact_people.first.update_column :email_id, email.id

      offer3 = FactoryGirl.create :offer, :approved,
                                  name: 'By mailings=disabled organization'
      offer3.contact_people.first.update_column :email_id, email.id
      offer3.organizations.first.update_column :mailings, 'force_disabled'

      assert_difference 'OfferMailing.count', 2 do # lists offer and offer2
        subject.must have_body_text offer.name
        subject.must have_body_text 'By mailings=enabled organization'
        subject.wont have_body_text 'By mailings=disabled organization'
      end
    end

    describe 'for a genderless contact person without a name' do
      let(:options) do
        { gender: nil, first_name: nil, last_name: nil, local_number_1: '1' }
      end

      it 'must address them correctly' do
        subject.must have_body_text 'Sehr geehrte Damen und Herren,'
      end
    end

    describe 'for an email with multiple contact people' do
      it 'must address them correctly' do
        FactoryGirl.create :contact_person, email: email
        subject.must have_body_text 'Sehr geehrte Damen und Herren,'
      end
    end

    describe 'for a male contact person with only a first name' do
      let(:options) { { gender: 'male', first_name: 'Foobar', last_name: '' } }

      it 'must address them correctly' do
        subject.must have_body_text 'Lieber Foobar,'
      end
    end

    describe 'for a male contact person with first and last name' do
      let(:options) { { gender: 'male', first_name: 'X', last_name: 'Bar' } }

      it 'must address them correctly' do
        subject.must have_body_text 'Lieber Herr Bar,'
      end
    end

    describe 'for a female contact person with only a last name' do
      let(:options) { { gender: 'female', first_name: '', last_name: 'Baz' } }

      it 'must address them correctly' do
        subject.must have_body_text 'Liebe Frau Baz,'
      end
    end

    describe 'for a female contact person with only a first name' do
      let(:options) { { gender: 'female', first_name: 'Fuz', last_name: nil } }

      it 'must address them correctly' do
        subject.must have_body_text 'Liebe Fuz,'
      end
    end

    describe 'CONTENT TEST' do
      it 'must contain stuff' do
        subject.must have_body_text 'Das ist ein neues kostenloses Onlineverzeichnis mit Unterstützungsangeboten.'
      end
    end
  end

  describe '#inform_organization_context' do
    let(:email) do
      FactoryGirl.create :email, :with_security_code, address: 'foo@bar.baz'
    end

    subject { OfferMailer.inform_organization_context email }
    before { contact_person }

    it 'must deliver and create orga_mailings with x-smtpapi header' do
      subject.must deliver_to 'foo@bar.baz'
      subject.must have_body_text 'clarat'
      subject.header['X-SMTPAPI'].value.must_include 'inform orga'
    end

    describe 'for a genderless contact person without a name' do
      let(:options) do
        { gender: nil, first_name: nil, last_name: nil, local_number_1: '1' }
      end

      it 'must address them correctly' do
        subject.must have_body_text 'Sehr geehrte Damen und Herren,'
      end
    end

    describe 'for an email with multiple contact people' do
      it 'must address them correctly' do
        FactoryGirl.create :contact_person, email: email
        subject.must have_body_text 'Sehr geehrte Damen und Herren,'
      end
    end

    describe 'for a male contact person with only a first name' do
      let(:options) { { gender: 'male', first_name: 'Foobar', last_name: '' } }

      it 'must address them correctly' do
        subject.must have_body_text 'Lieber Foobar,'
      end
    end

    describe 'for a male contact person with first and last name' do
      let(:options) { { gender: 'male', first_name: 'X', last_name: 'Bar' } }

      it 'must address them correctly' do
        subject.must have_body_text 'Lieber Herr Bar,'
      end
    end

    describe 'for a female contact person with only a last name' do
      let(:options) { { gender: 'female', first_name: '', last_name: 'Baz' } }

      it 'must address them correctly' do
        subject.must have_body_text 'Liebe Frau Baz,'
      end
    end

    describe 'for a female contact person with only a first name' do
      let(:options) { { gender: 'female', first_name: 'Fuz', last_name: nil } }

      it 'must address them correctly' do
        subject.must have_body_text 'Liebe Fuz,'
      end
    end

    describe 'CONTENT TEST' do
      it 'must contain stuff' do
        subject.must have_body_text 'Das ist ein neues kostenloses Onlineverzeichnis mit Unterstützungsangeboten.'
        subject.must have_body_text 'http://www.clarat.org/organisationen/'
        subject.must have_body_text 'clarat gGmbH'
      end
    end
  end

  describe '#newly_approved_offers' do
    let(:email) { FactoryGirl.create(:email, :with_security_code, :subscribed) }
    subject { OfferMailer.newly_approved_offers(email, offerArray) }

    before { contact_person }

    describe 'for a single offer' do
      let(:offerArray) { [offer] }

      it 'must deliver and create offer_mailings with x-smtpapi header' do
        email.expects(:create_offer_mailings)
        subject.must deliver_to email.address
        subject.header['X-SMTPAPI'].value.must_include 'newly approved offer'
        subject.header['X-SMTPAPI'].value.must_include offer.section.identifier
        subject.must have_subject "clarat #{offer.section.identifier} – Ihr neues Angebot"
        subject.must have_body_text 'ein neues Angebot'
        subject.must have_body_text '/unsubscribe/'
        subject.must have_body_text email.security_code
      end
    end

    describe 'for multiple offers' do
      let(:options) { { offers: offers } }
      let(:offerArray) do
        [
          offer,
          FactoryGirl.create(:offer, :approved, name: 'another named offer')
        ]
      end

      it 'must correctly mention them' do
        section_name_array = offerArray.map { |o| o.section.identifier }.flatten.compact.uniq.sort
        subject.must have_subject "clarat #{section_name_array.join(' und clarat ')} – Ihre neuen Angebote"
        subject.must have_body_text 'neue Angebote'
        subject.must have_body_text 'Ihre Angebote'
      end
    end
  end
end
