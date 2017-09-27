# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class OfferUpdateTest < ActiveSupport::TestCase
  include OperationTestUtils

  it 'gets updated with a submodel' do
    params = {
      data: {
        type: 'offers',
        id: '1',
        attributes: { description: 'changed' },
        relationships: {
          'contact-people': {
            data: [{
              type: 'contact-people',
              attributes: { 'first-name': 'New', 'last-name': 'Guy' },
              relationships: {
                organization: { data: { type: 'organizations', id: '1' } }
              }
            }]
          }
        }
      }
    }

    result =
      api_operation_must_work API::V1::Offer::Update, params.to_json
    result['model'].description.must_equal 'changed'
    result['model'].contact_people.count.must_equal 1
    result['model'].contact_people.last.display_name
                   .must_equal('#1 New Guy (foobar)')
  end
end
