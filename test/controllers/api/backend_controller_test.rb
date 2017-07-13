# frozen_string_literal: true
require_relative '../../test_helper'

module API::V1::BackendTest
  # rubocop:disable Style/EmptyLineBetweenDefs
  class PaginatedTestResult < Array
    def total_entries; 2; end
    def total_pages; 1; end
    def current_page; 1; end
    def per_page; 2; end
    def previous_page; nil; end
    def next_page; nil; end
  end
  # rubocop:enable Style/EmptyLineBetweenDefs

  class Index < API::V1::Default::Index
    def find_result_set(options, *)
      options['collection'] =
        PaginatedTestResult.new(
          [OpenStruct.new(id: 1, foo: 'bar'), OpenStruct.new(id: 2, foo: 'fuz')]
        )
    end
  end

  module Representer
    class Show < Roar::Decorator
      include Roar::JSON::JSONAPI.resource :tests

      attributes do
        property :foo
      end
    end

    class Index < Show
    end
  end
end

describe API::V1::BackendController do
  describe 'index_endpoint' do
    subject { API::V1::BackendController.new }
    it 'should handle a successful query' do
      expected_hash = {
        data: [
          { id: '1', attributes: { foo: 'bar' }, type: 'tests' },
          { id: '2', attributes: { foo: 'fuz' }, type: 'tests' }
        ],
        meta: {
          total_entries: 2, total_pages: 1, current_page: 1, per_page: 2
        },
        links: { previous: nil, next: nil }
      }
      subject.expects(:params).returns(controller: 'backend_test').twice
      subject.expects(:render).with(json: expected_hash.to_json, status: 200)
      subject.expects(:base_module).returns('API::V1::BackendTest').twice
      subject.index
    end
  end
end
