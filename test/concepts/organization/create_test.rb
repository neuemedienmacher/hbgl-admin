# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class OrganizationCreateTest < ActiveSupport::TestCase
  include OperationTestUtils

  it 'gets created with multiple submodels' do
    params = {
      data: {
        type: 'organizations',
        attributes: { name: 'foo' },
        relationships: {
          website: { data: { type: 'websites', id: '1' } },
          divisions: {
            data: [
              {
                type: 'divisions',
                attributes: { name: 'bar' },
                relationships: {
                  section: { data: { type: 'sections', id: '1' } }
                }
              },
              {
                type: 'divisions',
                attributes: { name: 'baz' },
                relationships: {
                  section: { data: { type: 'sections', id: '2' } }
                }
              }
            ]
          }
        }
      }
    }

    result =
      api_operation_must_work API::V1::Organization::Create, params.to_json
    result['model'].name.must_equal 'foo'
    result['model'].created_by.must_equal 1
    result['model'].website_id.must_equal 1
    result['model'].divisions.length.must_equal 2
    result['model'].divisions.first.name.must_equal 'bar'
    result['model'].divisions.first.section_id.must_equal 1
    result['model'].divisions.last.name.must_equal 'baz'
    result['model'].divisions.last.section_id.must_equal 2
  end
end
