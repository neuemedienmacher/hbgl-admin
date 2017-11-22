# frozen_string_literal: true

require_relative '../../test_helper'

module API::V1::BackendTest
  # rubocop:disable Layout/EmptyLineBetweenDefs
  class PaginatedTestResult < Array
    def total_entries; 2; end
    def total_pages; 1; end
    def current_page; 1; end
    def per_page; 2; end
    def previous_page; nil; end
    def next_page; nil; end
  end
  # rubocop:enable Layout/EmptyLineBetweenDefs

  class Index < API::V1::Default::Index
    def find_result_set(options, *)
      options['collection'] =
        PaginatedTestResult.new(
          [OpenStruct.new(id: 1, foo: 'bar'), OpenStruct.new(id: 2, foo: 'fuz')]
        )
    end
  end

  class TestOperation < Trailblazer::Operation
    step :one

    def one(*)
      true
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
  subject { API::V1::BackendController.new }

  describe 'index_endpoint' do
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

  describe 'destroy' do
    before do
      subject.expects(:delete_operation).returns(
        API::V1::BackendTest::TestOperation
      )
      subject.expects(:params).returns({})
      subject.expects(:current_user).returns(users(:researcher))
      subject.expects(:model_class_name).returns('API::V1::Default')
    end

    it 'should only render an empty json hash on success' do
      subject.expects(:render).with(json: {}, status: 200)
      subject.destroy
    end

    it 'should render errors on failure' do
      API::V1::BackendTest::TestOperation
        .any_instance.expects(:one).returns(false)
      subject.expects(:render).with(json: { errors: [] }, status: 403)
      subject.destroy
    end
  end
end
