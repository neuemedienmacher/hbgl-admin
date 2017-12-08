# frozen_string_literal: true

require_relative '../test_helper'

describe Location do
  subject { Location.new }

  describe 'partial_dup' do
    it 'should correctly duplicate an location' do
      location = FactoryBot.create :location, :hq
      duplicate = location.partial_dup
      duplicate.hq.must_equal false
      duplicate.offers.must_equal []
      duplicate.organization.must_equal location.organization
      duplicate.federal_state.must_equal location.federal_state
    end
  end
end
