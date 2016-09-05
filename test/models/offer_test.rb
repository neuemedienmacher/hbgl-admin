# frozen_string_literal: true
require_relative '../test_helper'

describe Offer do
  let(:offer) { Offer.new }
  let(:basicOffer) { offers(:basic) }

  subject { offer }

  describe '::Base' do
    describe 'associations' do
      it { subject.must have_many :offer_mailings }
      it { subject.must have_many(:informed_emails).through :offer_mailings }
    end

    # describe 'scopes' do
    #   it 'excludes offers that are not approved' do
    #     unapproved_offer = FactoryGirl.create :offer, :approved
    #     Offer.approved.to_a.should include(unapproved_offer)
    #   end
    # end

    describe 'seasonal scope' do
      it 'should correctly retrieve only seasonal offers with seasonal scope' do
        seasonal_offer = FactoryGirl.create :offer,
                                            starts_at: Time.zone.now - 30.days,
                                            expires_at: Time.zone.now + 30.days
        FactoryGirl.create :offer # additional normal offer
        Offer.seasonal.must_equal [seasonal_offer]
      end
    end

    describe 'partial_dup' do
      it 'should correctly duplicate an offer' do
        offer = FactoryGirl.create :offer, :approved
        duplicate = offer.partial_dup
        duplicate.created_by.must_equal nil
        duplicate.location.must_equal offer.location
        duplicate.organizations.must_equal offer.organizations
        duplicate.openings.must_equal offer.openings
        duplicate.categories.must_equal offer.categories
        duplicate.section_filters.must_equal offer.section_filters
        duplicate.language_filters.must_equal offer.language_filters
        duplicate.target_audience_filters.must_equal offer.target_audience_filters
        duplicate.websites.must_equal offer.websites
        duplicate.contact_people.must_equal offer.contact_people
        duplicate.keywords.must_equal offer.keywords
        duplicate.area.must_equal offer.area
        duplicate.aasm_state.must_equal 'initialized'
      end
    end

    describe 'validations' do
      it 'should validate that section filters of offer and categories fit '\
         'and that the correct error messages are generated' do
        category = FactoryGirl.create(:category)
        category.section_filters = [filters(:family)]
        basicOffer.categories = [category]
        basicOffer.section_filters = [filters(:refugees)]
        basicOffer.valid?
        basicOffer.errors.messages[:categories].must_include(
          "benötigt mindestens eine 'Refugees' Kategorie\n"
        )
        basicOffer.errors.messages[:categories].wont_include(
          "benötigt mindestens eine 'Family' Kategorie\n"
        )
        basicOffer.section_filters = [filters(:family), filters(:refugees)]
        category.section_filters = [filters(:refugees)]
        basicOffer.valid?
        basicOffer.errors.messages[:categories].must_include(
          "benötigt mindestens eine 'Family' Kategorie\n"
        )
        basicOffer.errors.messages[:categories].wont_include(
          "benötigt mindestens eine 'Refugees' Kategorie\n"
        )
        category.section_filters = [filters(:refugees), filters(:family)]
        basicOffer.valid?
        basicOffer.errors.messages[:categories].must_be :nil?
      end
    end

    describe '#remote_or_belongs_to_informable_city?' do
      it 'must be true for a personal offer with all_done organization' do
        location_offer = FactoryGirl.create :offer, :approved, :with_location
        location_offer.organizations.first.update_columns aasm_state: 'all_done'
        location_offer.remote_or_belongs_to_informable_city?.must_equal true
      end

      it 'must be false for a personal offer with approved organization' do
        location_offer = FactoryGirl.create :offer, :approved, :with_location
        location_offer.location.city = City.new(name: 'Bielefeld')
        location_offer.organizations.first.update_columns aasm_state: 'approved'
        location_offer.remote_or_belongs_to_informable_city?.must_equal false
      end

      it 'must be true for a remote offer with a city-area' do
        remote_offer = FactoryGirl.create :offer, :approved, encounter: 'chat'
        remote_offer.area = FactoryGirl.create :area, name: 'Berlin'
        remote_offer.organizations.first.update_columns aasm_state: 'all_done'
        remote_offer.remote_or_belongs_to_informable_city?.must_equal true
      end

      it 'must be true for a remote offer with area that does not match a city' do
        remote_offer = FactoryGirl.create :offer, :approved, encounter: 'chat'
        remote_offer.area = FactoryGirl.create :area, name: 'NotACity'
        remote_offer.organizations.first.update_columns aasm_state: 'approved'
        remote_offer.remote_or_belongs_to_informable_city?.must_equal true
      end
    end
  end
end
