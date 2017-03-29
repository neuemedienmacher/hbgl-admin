# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class StatisticTransitionCreateIfNecessaryTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  subject { ::StatisticTransition::CreateIfNecessary }
  let(:params) do
    {
      klass_name: 'Foo', field_name: 'bar', start_value: 'baz',
      end_value: 'fuz'
    }
  end

  describe 'StatisticTransition::CreateIfNecessary' do
    it 'finds an exisiting transition that maches given params' do
      transition = StatisticTransition.create(params)
      result = operation_must_work(subject, params)
      result['model'].must_equal transition
    end

    it 'creates a transition when no matching one exists' do
      operation_must_work(subject, params)
    end
  end
end
