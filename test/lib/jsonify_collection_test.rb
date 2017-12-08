# frozen_string_literal: true

require_relative '../test_helper'

class JsonifyCollectionTest < ActiveSupport::TestCase
  subject { API::V1::Lib::JsonifyCollection }

  it 'calls #for_collection on the representer and adds meta information' do
    collection = Tag.paginate(page: 2, per_page: 1)
    4.times do
      FactoryBot.create :tag
    end
    params = {
      'controller' => 'controller', 'action' => 'action',
      'format' => 'xml-csv', 'foo' => 'bar'
    }
    result =
      subject.call(API::V1::Tag::Representer::Show, collection, params)
    result.class.must_equal String
    result_hash = JSON.parse result
    result_hash['data'].class.must_equal Array
    result_hash['meta']['total_entries'].must_equal 5
    result_hash['meta']['total_pages'].must_equal 5
    result_hash['meta']['current_page'].must_equal 2
    result_hash['meta']['per_page'].must_equal 1
    result_hash['links']['previous'].must_equal '/controller?foo=bar&page=1'
    result_hash['links']['next'].must_equal '/controller?foo=bar&page=3'
  end
end
