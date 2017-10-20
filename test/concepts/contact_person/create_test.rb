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
