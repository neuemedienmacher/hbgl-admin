require_relative '../test_helper'

describe OrgaMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:offer) { offers(:basic) }
  let(:contact_person) do
    FactoryGirl.create(:contact_person,
                       { email: email, offers: [offer] }.merge(options))
  end
  let(:options) { {} }

  describe '#inform' do
    let(:email) do
      FactoryGirl.create :email, :with_security_code, address: 'foo@bar.baz'
    end

    subject { OrgaMailer.inform email }
    before { contact_person }

    it 'must deliver and create orga_mailings' do
      subject.must deliver_to 'foo@bar.baz'
      subject.must have_body_text 'clarat'
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
        subject.must have_body_text 'Das ist ein neues kostenloses Portal mit Unterstützungsangeboten.'
        subject.must have_body_text 'http://www.clarat.org/organisationen/'
        subject.must have_body_text 'clarat gGmbH'
      end
    end
  end
end
