# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class ContactPersonTranslationCreateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:cont) { FactoryGirl.create :contact_person }
  let(:basic_params) do
    {
      contact_person_id: cont.id,
      responsibility: 'ContactPersonResponsibility',
      source: 'GoogleTranslate',
      locale: 'pl'
    }
  end

  describe '::ContactPersonTranslation::Create' do
    it 'must create an ContactPersonTranslation given valid data' do
      operation_must_work ::ContactPersonTranslation::Create, basic_params
    end
  end

  describe '::ContactPersonTranslation::Index' do
    it 'base_query must be ::ContactPersonTranslation per default' do
      ::API::V1::ContactPersonTranslation::Index.new.base_query.must_equal ::ContactPersonTranslation
    end
  end
end
