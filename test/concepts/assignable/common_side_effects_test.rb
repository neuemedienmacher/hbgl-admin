# frozen_string_literal: true
require_relative '../../test_helper'

class Assignable::CommonSideEffectsTest < ActiveSupport::TestCase
  describe 'CreateNewAssignment' do
    let(:subject) do
      Class.new { include Assignable::CommonSideEffects::CreateNewAssignment }
    end
    let(:options) do
      {
        'model' => divisions(:basic),
        'current_user' => users(:researcher),
        'contract.default' => OpenStruct.new(
          errors: Reform::Form::ActiveModel::Errors.new(a: 'b')
        )
      }
    end

    let(:sym_options) do
      options.map { |key, value| [key.to_sym, value] }.to_h
    end

    it 'should copy deep assignment create errors' do
      # stub Assignment::Create errors
      errors = Reform::Form::ActiveModel::Errors.new foo: 'bar'
      errors.add :foo, 'baz'
      ::Assignment::Contracts::Create.any_instance.stubs(:errors).returns errors

      # test side effect method
      result = subject.new.create_initial_assignment!(options, sym_options)
      result.must_equal false # redirects to left (failure) track
      options['contract.default'].errors.messages.must_equal(
        foo: ['baz']
      )
    end
  end
end
