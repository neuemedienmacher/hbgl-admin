# frozen_string_literal: true

require_relative '../test_helper'

class ReformedValidationHackTest < ActiveSupport::TestCase
  module Contracts
    class Create < Reform::Form
      property :name
      validates :name, presence: true
    end
  end

  it 'should validate from the given contract' do
    empty_model = Offer.new
    empty_model.wont_be :valid?
    valid_model = Offer.new name: 'bar'
    valid_model.stubs(:_rvhacky_contract_for).returns(Contracts::Create)
    valid_model.must_be :valid?
    assert valid_model.errors.messages == {}
  end
end
