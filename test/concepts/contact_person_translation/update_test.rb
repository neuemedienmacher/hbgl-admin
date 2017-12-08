# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class ContactPersonTranslationUpdateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:super) }
  let(:cont) { FactoryBot.create :contact_person }
  let(:basic_params) do
    {
      id: cont.translations.find_by(locale: I18n.locale).id,
      responsibility: 'UpdatedContactPersonResponsibility'
    }
  end

  describe '::ContactPersonTranslation::Update' do
    it 'must update an ContactPersonTranslation given valid data' do
      result =
        operation_must_work ::ContactPersonTranslation::Update, basic_params
      result['model'].responsibility.must_equal(
        'UpdatedContactPersonResponsibility'
      )
    end
  end
end
