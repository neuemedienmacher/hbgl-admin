# frozen_string_literal: true
require_relative '../test_helper'

class ReformedValidationHackTest < ActiveSupport::TestCase
  class HackyTestModel < ActiveRecord::Base
    def self.columns() []; end
    attr_accessor :foo

    include ReformedValidationHack

    module Contracts
      class Create < Reform::Form
        property :foo
        validates :foo, presence: true
      end
    end
  end

  class ClassicTestModel < ActiveRecord::Base
    def self.columns() []; end
    attr_accessor :foo
    validates :foo, presence: true
  end

  it 'should validate from the given contract' do
    empty_model = HackyTestModel.new
    empty_reference_model = ClassicTestModel.new
    empty_model.wont_be :valid?
    empty_reference_model.wont_be :valid?
    empty_model.errors.messages.must_equal empty_reference_model.errors.messages

    valid_model = HackyTestModel.new foo: 'bar'
    valid_model.must_be :valid?
    assert valid_model.errors.messages == {}
  end
end
