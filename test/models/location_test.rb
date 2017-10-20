# frozen_string_literal: true

require_relative '../test_helper'

describe Location do
  subject { Location.new }

  describe 'partial_dup' do
    it 'should correctly duplicate an location' do
      location = FactoryGirl.create :location, :hq
      duplicate = location.partial_dup
      duplicate.hq.must_equal false
      duplicate.offers.must_equal []
      duplicate.organization.must_equal location.organization
      duplicate.federal_state.must_equal location.federal_state
    end
  end

  describe 'Observer' do
    it 'should call index on approved offers after visible change' do
      loc = locations(:basic)
      # add another offer - both must be re-indexed
      another_offer = FactoryGirl.create(:offer, :approved, :with_location)
      another_offer.organizations.map do |orga|
        orga.locations << loc
      end
      another_offer.location_id = loc.id
      another_offer.save!
      # add unapproved offer => should not be re-indexed
      initialized_offer = FactoryGirl.create(:offer, :with_location)
      initialized_offer.organizations.map do |orga|
        orga.locations << loc
      end
      initialized_offer.location = loc
      initialized_offer.save!
      Offer.any_instance.expects(:index!).times(loc.offers.visible_in_frontend.count)
      loc.visible = !loc.visible
      loc.save!
    end

    it 'should not update on irrelevant location change but on zip' do
      loc = FactoryGirl.create(:location)
      loc.assign_attributes(longitude: 5, latitude: 5)
      # add another offer - both must be re-indexed
      another_offer = FactoryGirl.create(:offer, :approved, :with_location)
      another_offer.organizations.map do |orga|
        orga.locations << loc
      end
      another_offer.location_id = loc.id
      another_offer.save!
      loc.after_commit
      loc.reload
      another_offer.reload
      another_offer._geoloc.must_equal('lat' => 5, 'lng' => 5)
      loc.assign_attributes(zip: 100_05)
      loc.save!
      loc.after_commit
      loc.reload
      another_offer.reload
      another_offer._geoloc.must_equal('lat' => 10, 'lng' => 20)
    end

    it 'should update offer on street change' do
      loc = FactoryGirl.create(:location)
      # add another offer - both must be re-indexed
      another_offer = FactoryGirl.create(:offer, :approved, :with_location)
      another_offer.organizations.map do |orga|
        orga.locations << loc
      end
      another_offer.location_id = loc.id
      another_offer.save!
      loc.assign_attributes(street: '10005')
      loc.save!
      loc.after_commit
      loc.reload
      another_offer.reload
      another_offer._geoloc.must_equal('lat' => 10, 'lng' => 20)
    end

    it 'should update offer on federal state change' do
      loc = FactoryGirl.create(:location)
      # add another offer - both must be re-indexed
      another_offer = FactoryGirl.create(:offer, :approved, :with_location)
      another_offer.organizations.map do |orga|
        orga.locations << loc
      end
      another_offer.location_id = loc.id
      another_offer.save!
      loc.federal_state = FederalState.create(name: 'Malle')
      loc.save!
      loc.after_commit
      loc.reload
      another_offer.reload
      another_offer._geoloc.must_equal('lat' => 10, 'lng' => 20)
    end

    it 'should update offer on city change' do
      loc = FactoryGirl.create(:location)
      # add another offer - both must be re-indexed
      another_offer = FactoryGirl.create(:offer, :approved, :with_location)
      another_offer.organizations.map do |orga|
        orga.locations << loc
      end
      another_offer.location_id = loc.id
      another_offer.save!
      loc.city = City.create(name: 'Metropolis')
      loc.save!
      loc.after_commit
      loc.reload
      another_offer.reload
      another_offer._geoloc.must_equal('lat' => 10, 'lng' => 20)
    end
  end
end
