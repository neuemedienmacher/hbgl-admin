# frozen_string_literal: true
require_relative '../test_helper'
# rubocop:disable Metrics/ClassLength
class GenericSortFilterTest < ActiveSupport::TestCase
  subject { GenericSortFilter }
  let(:query) { Offer.where('1 = 1') }
  let(:invalid_query) { OpenStruct.new }

  describe '#snake_case_contents' do
    it 'should transform kebab-case contents to snake_case' do
      params = {
        sort_field: 'foo-bar', sort_model: 'split-base', sort_direction: 'ASC',
        filters: { 'split-base.foo-bar' => 'dont-touch' }
      }
      result = subject.send(:snake_case_contents, params)
      result.must_equal(
        sort_field: 'foo_bar', sort_model: 'split_base', sort_direction: 'ASC',
        filters: { 'split_base.foo_bar' => 'dont-touch' }
      )
    end
  end

  describe '#transform_by_searching' do
    it 'does nothing without a param' do
      invalid_query.expects(:search_pg).never
      result = subject.send(:transform_by_searching, invalid_query, nil)
      result.must_equal invalid_query
    end

    it 'does nothing with an empty param' do
      invalid_query.expects(:search_pg).never
      result = subject.send(:transform_by_searching, invalid_query, '')
      result.must_equal invalid_query
    end

    it 'searches with a filled param for offer' do
      query.expects(:search_pg).with('foo').once
      subject.send(:transform_by_searching, query, 'foo')
    end

    it 'searches with a filled param for orga' do
      orga_query = Organization.where('1 = 1')
      orga_query.expects(:with_pg_search_rank).once
      subject.send(:transform_by_searching, orga_query, 'orga')
    end
  end

  describe '#transform_by_joining' do
    it 'eager_loads with a sort_model' do
      params = { sort_model: 'contact_people.fooooo' }
      query.expects(:joins).with('contact_people')
      subject.send(:transform_by_joining, query, params)
    end

    it 'eager_loads with a filter' do
      params = { filters: { 'split_base.foo' => 'a', 'logic_version.bar' => 'b' } }
      query.expects(:joins).with(:split_base).returns(query)
      query.expects(:joins).with(:logic_version).returns(query)
      result = subject.send(:transform_by_joining, query, params)
      result.must_equal query
    end

    it 'wont eager_load without a sort_model or filter' do
      invalid_query.expects(:joins).never
      result = subject.send(:transform_by_joining, invalid_query, {})
      result.must_equal invalid_query
    end

    it 'wont eager_load with a filter that references itself' do
      params = { filters: ['offer.baz'] }
      query.expects(:joins).never
      subject.send(:transform_by_joining, query, params)
    end

    it 'wont eager_load with a filter that uses no submodel' do
      params = { filters: ['fuz'] }
      query.expects(:joins).never
      subject.send(:transform_by_joining, query, params)
    end
  end

  describe '#transform_by_ordering' do
    it 'wont transform without a sort_field' do
      invalid_query.expects(:order).never
      result = subject.send(:transform_by_ordering, invalid_query, {})
      result.must_equal invalid_query
    end

    it 'will order with a sort_field but without sort_model' do
      params = { sort_field: 'foo' }
      query.expects(:order).with('foo DESC')
      subject.send(:transform_by_ordering, query, params)
    end

    it 'will order respecting sort_field, sort_model, and sort_direction' do
      params =
        { sort_field: 'bar', sort_model: 'split_base', sort_direction: 'ASC' }
      query.expects(:order).with('split_bases.bar ASC')
      subject.send(:transform_by_ordering, query, params)
    end
  end

  describe '#check_if_reflection' do
    it 'should classifiy and constantize for self-referring query' do
      subject.send(:check_if_reflection, query, 'offer.name').must_equal Offer
    end
  end

  describe '#transform_by_filtering' do
    it 'wont transform without filters' do
      params = { filters: nil }
      invalid_query.expects(:where).never
      result = subject.send(:transform_by_filtering, invalid_query, params)
      result.must_equal invalid_query
    end

    it 'wont transform with an empty filter set' do
      params = { filters: {} }
      invalid_query.expects(:where).never
      result = subject.send(:transform_by_filtering, invalid_query, params)
      result.must_equal invalid_query
    end

    it 'wont transform with an empty filter value' do
      params = { filters: { foo: '' } }
      invalid_query.expects(:where).never
      result = subject.send(:transform_by_filtering, invalid_query, params)
      result.must_equal invalid_query
    end

    it 'filters for an owned field' do
      params = { filters: { 'foo' => 'bar' }, controller: 'api/controller' }
      query.expects(:where).with("controller.foo = 'bar'")
      subject.send(:transform_by_filtering, query, params)
    end

    it 'filters for an array of owned field with default OR-joining' do
      params = { filters: { 'foo' => %w(bar fuz) } }
      query.expects(:where).with("foo = 'bar' OR foo = 'fuz'")
      subject.send(:transform_by_filtering, query, params)
    end

    it 'filters for an array of owned field with !=-operator and AND-joining' do
      params = { filters: { 'x' => %w(bar fuz) }, operators: { 'x' => '!=' } }
      query.expects(:where)
           .with("x != 'bar' OR x IS NULL AND x != 'fuz' OR x IS NULL")
      subject.send(:transform_by_filtering, query, params)
    end

    it 'filters with a mismatching association/table name' do
      params = { filters: { 'language_filters.foobar' => 'bazfuz' } }
      query.expects(:where).with("filters.foobar = 'bazfuz'")
      subject.send(:transform_by_filtering, query, params)
    end

    it 'filters with a nullable value' do
      params = { filters: { 'split_base.baz' => 'nil' } }
      query.expects(:where).with('split_bases.baz IS NULL')
      subject.send(:transform_by_filtering, query, params)
    end

    it 'filters with a nullable value and NOT operator value' do
      params = { filters: { 'fuz' => 'NULL' }, operators: { 'fuz' => '!=' } }
      query.expects(:where).with('fuz IS NOT NULL')
      subject.send(:transform_by_filtering, query, params)
    end

    it 'includes NULL values for a "!=" string search' do
      params =
        { filters: { 'title' => 'smth' }, operators: { 'title' => '!=' } }
      query.expects(:where).with("title != 'smth' OR title IS NULL")
      subject.send(:transform_by_filtering, query, params)
    end

    it 'parses date-times and converts them from CET to UTC' do
      params = { filters: { 'created_at' => '15.09.2014, 13:02:00+0200' } }
      query.expects(:where).with("created_at = '2014-09-15T11:02:00+00:00'")
      subject.send(:transform_by_filtering, query, params)
    end
  end
end
# rubocop:enable Metrics/ClassLength
