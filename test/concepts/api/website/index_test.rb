# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../support/utils/operation_test_utils'

class WebsiteIndexTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:options) do
    { 'query' => 'https://doesntmatter' }
  end

  describe '::Website::Index' do
    it 'should remove https from query string' do
      result = run_operation ::API::V1::Website::Index, options
      result['params']['query'].must_equal 'doesntmatter'
    end

    it 'should remove http from query string' do
      options['query'] = 'http://doesntmatter'
      result = run_operation ::API::V1::Website::Index, options
      result['params']['query'].must_equal 'doesntmatter'
    end

    it 'should not do anything when http does not stand at the beginning' do
      options['query'] = 'www.doesntmatter.org/http://'
      result = run_operation ::API::V1::Website::Index, options
      result['params']['query'].must_equal 'www.doesntmatter.org/http://'
    end
  end
end
