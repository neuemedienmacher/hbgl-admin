# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class ContactPersonCreateTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:orga) { organizations(:basic) }
  let(:basic_params) do
    {
      first_name: 'ContactPersonName',
      organization: orga
    }
  end

  describe 'methods' do
    describe '#label' do
      it 'should show ID, name and organization name and phone number' do
        email = Email.create!(address: 'bla@blub.de')
        params = {
          first_name: 'John',
          last_name: 'Doe',
          position: 'superior',
          area_code_1: '123',
          local_number_1: '456767',
          email: { id: email.id },
          organization: orga
        }
        result = operation_must_work ::ContactPerson::Create, params
        result['model'].label.must_equal "Chef: ##{result['model'].id} John"\
          ' Doe (foobar) bla@blub.de 123 456767'
      end

      it 'should show ID, name and organization name and email' do
        params = {
          operational_name: 'Headquarters',
          organization: orga
        }
        result = operation_must_work ::ContactPerson::Create, params
        result['model'].label.must_equal "##{result['model'].id} Headquarters"\
          ' (foobar) '
      end
    end
  end

  describe '::ContactPerson::Create' do
    it 'must create a ContactPerson given valid data' do
      operation_must_work ::ContactPerson::Create, basic_params
    end

    describe 'validations' do
      it 'must validate first_name when nothing else is given' do
        basic_params[:first_name] = nil
        operation_wont_work ::ContactPerson::Create, basic_params
      end

      it 'must validate organization' do
        basic_params[:organization] = nil
        operation_wont_work ::ContactPerson::Create, basic_params
      end

      # TODO: more validation test (see contract)
    end
  end
end
