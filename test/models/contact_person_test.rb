# frozen_string_literal: true
require_relative '../test_helper'

describe ContactPerson do
  let(:contact_person) { ContactPerson.new }

  subject { contact_person }

  describe 'methods' do
    describe '#display_name' do
      it 'should show ID, name and organization name' do
        contact_person.assign_attributes id: 1, first_name: 'John'
        contact_person.assign_attributes id: 1, last_name: 'Doe'
        contact_person.organization = Organization.new(name: 'ABC')
        contact_person.display_name.must_equal '#1 John Doe (ABC)'
      end

      it 'should show ID, name and organization name' do
        contact_person.assign_attributes id: 1, operational_name: 'Headquarters'
        contact_person.organization = Organization.new(name: 'ABC')
        contact_person.display_name.must_equal '#1 Headquarters (ABC)'
      end

      it 'should show ID, name, position and organization name' do
        contact_person.assign_attributes id: 1, first_name: 'John'
        contact_person.assign_attributes id: 1, last_name: 'Doe'
        contact_person.assign_attributes id: 1, position: 'superior'
        contact_person.organization = Organization.new(name: 'ABC')
        contact_person.display_name.must_equal 'Chef: #1 John Doe (ABC)'
      end
    end
  end

  describe 'translation' do
    it 'should create initial translatins' do
      new_cont = FactoryGirl.create(:contact_person)
      new_cont.responsibility = 'responsibility text'
      new_cont.translations.count.must_equal I18n.available_locales.count
      new_cont.responsibility.must_equal 'responsibility text'
      new_cont.reload.responsibility_ar.must_equal 'GET READY FOR CANADA'
    end

    it 'should update an existing translation only when the field changed' do
      # Setup
      new_cont = FactoryGirl.create(:contact_person)
      new_cont.run_callbacks(:commit) # Hotfix: force commit callback
      new_cont.translations.count.must_equal I18n.available_locales.count

      # Now changes to the model change the corresponding translated fields
      EasyTranslate.translated_with 'CHANGED' do
        new_cont.responsibility_ar.must_equal 'GET READY FOR CANADA'
        # changing untranslated field => translations must stay the same
        new_cont.reload.responsibility_ar.must_equal 'GET READY FOR CANADA'
        new_cont.responsibility = 'changing responsibility, should update translation'
        new_cont.save!
        new_cont.run_callbacks(:commit) # Hotfix: force commit callback
        new_cont.reload.responsibility_ar.must_equal 'CHANGED'
      end
    end
  end
end
