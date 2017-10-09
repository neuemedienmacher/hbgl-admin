# frozen_string_literal: true

require_relative '../test_helper'

class JsonapiErrorsTest < ActiveSupport::TestCase
  subject { JsonapiErrors }
  let(:error_hash) { { errors: ['initial'] } }

  describe '::add_authentication_errors' do
    it 'must add a policy.default error' do
      template = { 'result.policy.default' => { 'message' => 'foo' } }
      result = subject.send(:add_authentication_errors, template, error_hash)
      result.must_equal(errors: ['initial', { title: 'foo' }])
    end

    it 'must ignore an empty policy' do
      template = { 'result.policy.default' => nil }
      result = subject.send(:add_authentication_errors, template, {})
      result.must_equal({})
    end
  end

  describe '::add_contract_errors' do
    let(:errors) { ActiveModel::Errors.new(OpenStruct.new) }
    let(:contract) { OpenStruct.new(errors: errors) }
    let(:template) { { 'contract.default' => contract } }

    it 'must add a contract.default error (with kebab-cased pointer)' do
      errors.add :foo_bar, 'baz'
      result = subject.send(:add_contract_errors, template, error_hash)
      result.must_equal(
        errors: [
          'initial',
          { title: 'baz', source: { pointer: '/data/attributes/foo-bar' } }
        ]
      )
    end

    it 'must add pointers to deeply nested errors' do
      errors.add :multi, 0 => { thing: ['smells', 'is ugly'], lard: 'no bueno' }
      errors.add :deep, 2 => { deeper: { deepest: '2deep4me' } }

      result = subject.send(:add_contract_errors, template, error_hash)
      result.must_equal(
        errors: [
          'initial',
          {
            title: 'smells',
            source: {
              pointer: '/data/relationships/multi/data/0/attributes/thing'
            }
          }, {
            title: 'is ugly',
            source: {
              pointer: '/data/relationships/multi/data/0/attributes/thing'
            }
          }, {
            title: 'no bueno',
            source: {
              pointer: '/data/relationships/multi/data/0/attributes/lard'
            }
          }, {
            title: '2deep4me',
            source: {
              pointer: '/data/relationships/deep/data/2/relationships/deeper'\
                       '/data/attributes/deepest'
            }
          }
        ]
      )
    end
  end
end
