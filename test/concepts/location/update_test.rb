# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class LocationUpdateTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:loc) { FactoryGirl.create(:location) }

  describe '::Location::Update' do
    it 'must update a Location given valid data' do
      operation_must_work(
        ::Location::Update, id: loc.id, street: 'newStreetName'
      )
    end

    describe 'Geolocation' do
      it 'should update long/lat values on street change' do
        loc.update_columns longitude: 5, latitude: 5
        operation_must_work(
          ::Location::Update, id: loc.id, street: 'newStreetName'
        )
        loc.reload.longitude.wont_equal 5
        loc.reload.latitude.wont_equal 5
      end

      it 'should NOT update long/lat values on unimportant change' do
        loc.update_columns longitude: 5, latitude: 5
        operation_must_work(
          ::Location::Update, id: loc.id, name: 'doesnMatter'
        )
        loc.reload.longitude.must_equal 5
        loc.reload.latitude.must_equal 5
      end
    end

    describe 'Offer Index side-effect' do
      it 'should re-index associated offers on visible change' do
        existing_location = Offer.first.location
        existing_location.update_columns visible: false
        existing_location.offers.count.wont_equal 0
        Offer.any_instance.expects(:index!)
        operation_must_work(
          ::Location::Update, id: existing_location.id, visible: true
        )
      end
    end
  end
end
