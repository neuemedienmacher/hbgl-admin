# frozen_string_literal: true
require_relative '../../test_helper'

module TestSuite
  class SubmodelTester < Trailblazer::Operation
    def model!(params)
      @model ||= params[:model]
    end

    include Trailblazer::Operation::Representer
    representer do
      include Roar::JSON::JSONAPI
      type :organizations
      property :name

      has_many :divisions, class: Division, populator: ::Representable::FindOrInstantiate do
        type :divisions
        property :name
      end
    end

    contract do
      property :name

      collection :divisions, populate_if_empty: Division do
        property :name
      end
    end

    def process(params)
      if validate params[:json]
        contract.save
      end
    end
  end
end

class OrganizationCreateTest < ActiveSupport::TestCase
  it 'gets created with multiple submodels' do
    params = {
      data: {
        type: 'organizations',
        attributes: { name: 'foo' },
        relationships: {
          divisions: {
            data: [
              { type: 'divisions', attributes: { name: 'bar' } },
              { type: 'divisions', attributes: { name: 'baz' } }
            ]
          }
        }
      }
    }
    opts = { model: Organization.new, json: params.to_json }
    _res, _op = TestSuite::SubmodelTester.run(opts)
    deprecate 'Is this reached?'
    true
  end
end
