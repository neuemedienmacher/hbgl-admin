# frozen_string_literal: true
require_relative '../test_helper'

class JsonapiWithPolymorphyTest < ActiveSupport::TestCase
  subject { API::V1::Lib::JsonapiWithPolymorphy }

  class Foo
    def id
      1
    end
  end

  class Bar
    attr_reader :id

    def initialize(id = 2)
      @id = id
    end

    def self.table_name
      'fuz'
    end
  end

  it 'must transform a single polymorphic association' do
    class SinglePolymorphic < Roar::Decorator
      include Roar::JSON::JSONAPI.resource :foos
      include API::V1::Lib::JsonapiWithPolymorphy

      has_one :bar do
        type :polymorphic
      end
    end

    class FooWithSingleBar < Foo
      def bar
        Bar.new
      end
    end

    result = SinglePolymorphic.new(FooWithSingleBar.new).to_hash
    result['data']['relationships']['bar']['data']['type'].must_equal 'fuz'
    result['data']['relationships']['bar']['data']['id'].must_equal '2'
    result['included'][0]['type'].must_equal 'fuz'
    result['included'][0]['id'].must_equal '2'
  end

  it 'must transform multiple polymorphic associations' do
    class MultiplePolymorphic < Roar::Decorator
      include Roar::JSON::JSONAPI.resource :foos
      include API::V1::Lib::JsonapiWithPolymorphy

      has_many :bars do
        type :polymorphic
      end
    end

    class FooWithMultipleBar < Foo
      def bars
        [Bar.new(3), Bar.new(4)]
      end
    end

    result = MultiplePolymorphic.new(FooWithMultipleBar.new).to_hash
    result['data']['relationships']['bars']['data'][0]['type'].must_equal 'fuz'
    result['data']['relationships']['bars']['data'][0]['id'].must_equal '3'
    result['data']['relationships']['bars']['data'][1]['type'].must_equal 'fuz'
    result['data']['relationships']['bars']['data'][1]['id'].must_equal '4'
    result['included'][0]['type'].must_equal 'fuz'
    result['included'][0]['id'].must_equal '3'
    result['included'][1]['type'].must_equal 'fuz'
    result['included'][1]['id'].must_equal '4'
  end
end
