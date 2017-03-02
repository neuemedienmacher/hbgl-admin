# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class ExportCreateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:basic_params) do
    {
      object_name: 'offers',
      export: {
        model_fields: %w(id name),
        section_filters: ['id']
      }
    }
  end
  let(:operation) { ::Export::Create }

  describe '::Export::Create' do
    it 'must create an Export given valid data' do
      result = run_operation operation, basic_params
      result.must_be :success?
    end

    describe '#instantiate_model' do
      it 'correctly creates a new Export model with an offer-object' do
        step_result = operation.new.instantiate_model({}, params: basic_params)
        step_result.class.must_equal ::Export
        step_result.object.must_equal ::Offer
      end
    end

    describe '#validate_model_fields' do
      it 'must return true for valid params' do
        m = operation.new.instantiate_model({}, params: basic_params)
        operation.new.validate_model_fields({}, basic_params, m).must_equal true
      end

      it 'must return false for invalid fields' do
        basic_params[:export][:model_fields] = ['DoesNotExist']
        m = operation.new.instantiate_model({}, params: basic_params)
        operation.new.validate_model_fields({}, basic_params, m).must_equal false
      end
    end

    describe '#clean_empty_field_sets' do
      it 'should not change anything for a valid input' do
        options = {}
        operation.new.clean_empty_field_sets(options, basic_params)
        options['params'][:export].must_equal(model_fields: %w(id name),
                                              section_filters: ['id'])
      end

      it 'should reject empty keys in export hash' do
        basic_params[:export][:mustBeRejected] = []
        options = {}
        operation.new.clean_empty_field_sets(options, basic_params)
        options['params'][:export].must_equal(model_fields: %w(id name),
                                              section_filters: ['id'])
      end
    end
  end
end
