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
              }, {
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

  it 'wont get created with faulty website submodel' do
    params = {
      data: {
        type: 'organizations',
        attributes: { name: 'foo' },
        relationships: {
          website: { data: { type: 'websites', attributes: {
            host: 'not a valid host',
            url: 'not a valid url'
          } } }
        }
      }
    }

    result =
      api_operation_wont_work API::V1::Organization::Create, params.to_json
    result['contract.default'].errors.to_h.must_equal(
      website: { host: 'muss ausgefüllt werden', url: 'ist nicht gültig' }
    )
  end

  it 'wont get created with faulty division submodels' do
    params = {
      data: {
        type: 'organizations',
        attributes: {},
        relationships: {
          divisions: {
            data: [
              {
                type: 'divisions',
                attributes: {}, # no name
                relationships: {
                  section: { data: { type: 'sections', id: '1' } },
                  websites: { data: [{
                    type: 'websites',
                    attributes: { host: 'own', url: 'invalid' }
                  }] }
                }
              }, {
                type: 'divisions',
                attributes: { name: 'baz' } # no section
              }
            ]
          }
        }
      }
    }

    result =
      api_operation_wont_work API::V1::Organization::Create, params.to_json
    result['contract.default'].errors.to_h[:divisions].must_equal(
      0 => {
        websites: { 0 => { url: 'ist nicht gültig' } },
        name: 'muss ausgefüllt werden'
      },
      1 => { section: 'muss ausgefüllt werden' }
    )
  end
end
