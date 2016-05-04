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
end
