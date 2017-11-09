# frozen_string_literal: true

require_relative '../test_helper'

describe ContactPerson do
  let(:contact_person) { ContactPerson.new }

  subject { contact_person }

  describe 'methods' do
    describe '#label' do
      it 'should show ID, name and organization name' do
        contact_person.assign_attributes id: 1, first_name: 'John'
        contact_person.assign_attributes id: 1, last_name: 'Doe'
        contact_person.organization = Organization.new(name: 'ABC')
        contact_person.label.must_equal '#1 John Doe (ABC)'
      end

      it 'should show ID, name and organization name' do
        contact_person.assign_attributes id: 1, operational_name: 'Headquarters'
        contact_person.organization = Organization.new(name: 'ABC')
        contact_person.label.must_equal '#1 Headquarters (ABC)'
      end

      it 'should show ID, name, position and organization name' do
        contact_person.assign_attributes id: 1, first_name: 'John'
        contact_person.assign_attributes id: 1, last_name: 'Doe'
        contact_person.assign_attributes id: 1, position: 'superior'
        contact_person.organization = Organization.new(name: 'ABC')
        contact_person.label.must_equal 'Chef: #1 John Doe (ABC)'
      end
    end
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of(:organization) }
      it { subject.must validate_length_of(:area_code_1).is_at_most 6 }
      it { subject.must validate_length_of(:local_number_1).is_at_most 32 }
      it { subject.must validate_length_of(:area_code_2).is_at_most 6 }
      it { subject.must validate_length_of(:local_number_2).is_at_most 32 }
      it { subject.must validate_length_of(:fax_area_code).is_at_most 6 }
      it { subject.must validate_length_of(:fax_number).is_at_most 32 }

      describe 'custom' do
        describe '#at_least_one_field_present' do
          let(:contact_person) do
            FactoryGirl.build :contact_person, :all_fields
          end
          before { contact_person.organization_id = 1 }

          it 'should be invalid if no first_name/last_name/operational_name/'\
             'local_number_1/fax_number is given' do
            contact_person.first_name = nil
            contact_person.last_name = nil
            contact_person.operational_name = nil
            contact_person.local_number_1 = nil
            contact_person.fax_number = nil
            contact_person.valid?.must_equal false
            contact_person.errors[:base].must_include(
              I18n.t('contact_person.validations.incomplete')
            )
          end

          it 'should be valid if first_name is given' do
            contact_person.first_name = 'John'
            contact_person.last_name = nil
            contact_person.operational_name = nil
            contact_person.local_number_1 = nil
            contact_person.fax_number = nil
            contact_person.valid?.must_equal true
          end

          it 'should be valid if last_name is given' do
            contact_person.first_name = nil
            contact_person.last_name = 'Doe'
            contact_person.operational_name = nil
            contact_person.local_number_1 = nil
            contact_person.fax_number = nil
            contact_person.valid?.must_equal true
          end

          it 'should be valid if operational_name is given' do
            contact_person.first_name = nil
            contact_person.last_name = nil
            contact_person.operational_name = 'CEO'
            contact_person.local_number_1 = nil
            contact_person.fax_number = nil
            contact_person.valid?.must_equal true
          end

          it 'should be valid if local_number_1 is given' do
            contact_person.first_name = nil
            contact_person.last_name = nil
            contact_person.operational_name = nil
            contact_person.local_number_1 = '123'
            contact_person.fax_number = nil
            contact_person.valid?.must_equal true
          end

          it 'should be valid if fax_number is given' do
            contact_person.first_name = nil
            contact_person.last_name = nil
            contact_person.operational_name = nil
            contact_person.local_number_1 = nil
            contact_person.fax_number = '123'
            contact_person.valid?.must_equal true
          end
        end
      end
    end
  end

  describe 'translation' do
    it 'should create initial translatins' do
      new_cont = FactoryGirl.create(
        :contact_person, responsibility: 'responsibility text'
      )
      new_cont.translations.count.must_equal I18n.available_locales.count
      new_cont.responsibility.must_equal 'responsibility text'
      new_cont.reload.responsibility_ar.must_equal 'GET READY FOR CANADA'
    end

    it 'should update an existing translation only when the field changed' do
      # Setup
      new_cont = FactoryGirl.create(:contact_person, responsibility: 'whatever')
      new_cont.run_callbacks(:commit) # Hotfix: force commit callback
      new_cont.translations.count.must_equal I18n.available_locales.count

      # Now changes to the model change the corresponding translated fields
      EasyTranslate.translated_with 'CHANGED' do
        new_cont.responsibility_ar.must_equal 'GET READY FOR CANADA'
        # changing untranslated field => translations must stay the same
        new_cont.reload.responsibility_ar.must_equal 'GET READY FOR CANADA'
        new_cont.responsibility =
          'changing responsibility, should update translation'
        new_cont.save!
        new_cont.run_callbacks(:commit) # Hotfix: force commit callback
        new_cont.reload.responsibility_ar.must_equal 'CHANGED'
      end
    end
  end
end
