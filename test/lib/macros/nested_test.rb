# frozen_string_literal: true
require_relative '../../test_helper'

# rubocop:disable Metrics/ClassLength
class NestedTest < ActiveSupport::TestCase
  class InnerContract < Reform::Form
    property :url
    validates :url, format: %r{\Ahttp://valid}
  end

  class MiddleContract < Reform::Form
    property :addition
    validates :addition, presence: true

    property :section_id
    validates :section_id, presence: true

    property :websites
  end

  class OuterContract < Reform::Form
    property :name
    validates :name, format: /\Avalid/

    property :website

    property :divisions
  end

  class InnerRepresenter < Roar::Decorator
    include Roar::JSON::JSONAPI.resource :websites
    attributes do
      property :url
    end
  end

  class MiddleRepresenter < Roar::Decorator
    include Roar::JSON::JSONAPI.resource :divisions
    attributes do
      property :addition
      property :section_id
    end
    has_many :websites, decorator: InnerRepresenter, class: ::Website,
                        populator: API::V1::Lib::Populators::FindOrInstantiate
  end

  class OuterRepresenter < Roar::Decorator
    include Roar::JSON::JSONAPI.resource :organizations
    attributes do
      property :name
    end
    has_one :website, decorator: InnerRepresenter, class: ::Website,
                      populator: API::V1::Lib::Populators::FindOrInstantiate
    has_many :divisions, decorator: MiddleRepresenter, class: ::Division,
                         populator: API::V1::Lib::Populators::FindOrInstantiate
  end

  module Inner # = Website
    class Create < Trailblazer::Operation
      step Model(::Website, :new)
      step Contract::Build(constant: InnerContract)
      step Contract::Validate()
      step :inner_side_effect!
      step Contract::Persist()
      def inner_side_effect!(_, model:, **)
        model.host = 'own'
        true
      end
    end
  end

  module Middle # = Division
    class Create < Trailblazer::Operation
      step Model(::Division, :new)
      step Contract::Build(constant: MiddleContract)
      step Contract::Validate()
      step Wrap(Lib::Transaction) {
        step Lib::Macros::Nested::Create(:websites, Inner::Create)
      }
      step Contract::Persist()
      step :middle_side_effect!
      def middle_side_effect!(_, model:, **)
        model.update_column :comment, 'middle side effect!'
      end
    end
  end

  module Outer # = Organization
    class Create < Trailblazer::Operation
      step Model(::Organization, :new)
      step Contract::Build(constant: OuterContract)
      step Contract::Validate()
      step Wrap(Lib::Transaction) {
        step Lib::Macros::Nested::Create(:website, Inner::Create)
        step Lib::Macros::Nested::Create(:divisions, Middle::Create)
      }
      # step Lib::Macros::Debug::Breakpoint() # !
      step Contract::Persist()
      step :outer_side_effect!
      def outer_side_effect!(_, model:, **)
        model.update_column :comment, 'outer side effect!'
      end
    end

    class ApiCreate < Create
      extend Trailblazer::Operation::Representer::DSL
      representer OuterRepresenter
    end
  end

  it 'should work too for an API' do
    jsonapi_hash = {
      data: {
        type: 'organizations',
        attributes: { name: 'valid1' },
        relationships: {
          website: {
            data: { type: 'websites', attributes: { url: 'http://valid2.com' } }
          },
          divisions: {
            data: [
              {
                type: 'divisions',
                attributes: { addition: 'valid3', 'section-id': 1 },
                relationships: {
                  websites: {
                    data: [{
                      type: 'websites',
                      attributes: { url: 'http://valid4.com' }
                    }]
                  }
                }
              }, {
                type: 'divisions',
                attributes: { addition: 'valid5', 'section-id': 2 },
                relationships: {
                  websites: {
                    data: [{
                      type: 'websites',
                      attributes: { url: 'http://valid6.com' }
                    }, {
                      type: 'websites', id: '1'
                    }]
                  }
                }
              }
            ]
          }
        }
      }
    }
    result = Outer::ApiCreate.({}, 'document' => jsonapi_hash.to_json)
    result.must_be :success?
    assert_test_model(result['model'])
  end

  it 'should work for a regular operation' do
    params = {
      name: 'valid1',
      website: { url: 'http://valid2.com' },
      divisions: [{
        addition: 'valid3',
        section_id: 1,
        websites: [{ url: 'http://valid4.com' }]
      }, {
        addition: 'valid5',
        section_id: 2,
        websites: [{ url: 'http://valid6.com' }, { id: '1' }]
      }]
    }
    result = Outer::Create.(params)
    result.must_be :success?
    assert_test_model(result['model'])
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def assert_test_model(model)
    model.must_be :persisted?
    model.name.must_equal 'valid1'
    model.comment.must_equal 'outer side effect!'
    model.website.must_be :persisted?
    model.website.url.must_equal 'http://valid2.com'
    model.website.host.must_equal 'own' # side effect
    model.divisions.count.must_equal 2
    model.divisions.first.must_be :persisted?
    model.divisions.first.addition.must_equal 'valid3'
    model.divisions.first.section_id.must_equal 1
    model.divisions.first.comment.must_equal 'middle side effect!'
    model.divisions.first.websites.first.must_be :persisted?
    model.divisions.first.websites.first.url.must_equal 'http://valid4.com'
    model.divisions.first.websites.first.host.must_equal 'own' # side effect
    model.divisions.last.must_be :persisted?
    model.divisions.last.addition.must_equal 'valid5'
    model.divisions.last.section_id.must_equal 2
    model.divisions.last.comment.must_equal 'middle side effect!'
    model.divisions.last.websites.count.must_equal 2
    model.divisions.last.websites.first.must_be :persisted?
    model.divisions.last.websites.first.url.must_equal 'http://valid6.com'
    model.divisions.last.websites.first.host.must_equal 'own' # side effect
    model.divisions.last.websites.last.url.must_equal 'http://basic.com'
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  it 'should work for update' do
    # TODO: Write update tests
  end

  describe '::Find' do
    it 'must raise when no ID was given' do
      class NoIdFindTest < Trailblazer::Operation
        extend Contract::DSL
        contract do
          property :rels
        end
        step Contract::Build()
        step Contract::Validate()
        step Lib::Macros::Nested::Find(:rels, OpenStruct.new(name: 'Foo'))
      end
      assert_raises(RuntimeError) do
        NoIdFindTest.({ rels: {} }, 'model' => OpenStruct.new(rels: nil))
      end
    end
  end

  describe '::error_from_result' do
    it 'returns a generic message for a non-contract-error problem' do
      mocked_result = { 'contract.default' => OpenStruct.new(errors: {}) }
      mocked_result.expects(:success?).returns false
      Lib::Macros::Nested.send(:error_from_result, mocked_result).must_equal(
        'Operation Failure'
      )
    end
  end
end
# rubocop:enable Metrics/ClassLength
