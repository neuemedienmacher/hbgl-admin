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

    describe 'scopes' do
      describe 'visible_in_frontend' do
        it 'includes offers that are approved or expired' do
          approved_offer = FactoryBot.create :offer, :approved
          expired = FactoryBot.create :offer, aasm_state: 'expired'
          Offer.visible_in_frontend.to_a.include?(
            approved_offer
          ).must_equal true
          Offer.visible_in_frontend.to_a.include?(expired).must_equal true
        end

        it 'excludes offers that are not approved or expired' do
          offer = FactoryBot.create :offer, aasm_state: 'completed'
          Offer.visible_in_frontend.to_a.include?(offer).must_equal false
          offer = FactoryBot.create :offer, aasm_state: 'initialized'
          Offer.visible_in_frontend.to_a.include?(offer).must_equal false
          offer = FactoryBot.create :offer, aasm_state: 'paused'
          Offer.visible_in_frontend.to_a.include?(offer).must_equal false
          offer = FactoryBot.create :offer, aasm_state: 'internal_feedback'
          Offer.visible_in_frontend.to_a.include?(offer).must_equal false
          offer = FactoryBot.create :offer, aasm_state: 'organization_'\
                                                         'deactivated'
          Offer.visible_in_frontend.to_a.include?(offer).must_equal false
          offer = FactoryBot.create :offer, aasm_state: 'website_unreachable'
          Offer.visible_in_frontend.to_a.include?(offer).must_equal false
        end
      end

      describe 'seasonal' do
        it 'should correctly retrieve only seasonal offers with'\
           'seasonal scope' do
          seasonal_offer =
            FactoryBot.create :offer, starts_at: Time.zone.now - 30.days,
                                      ends_at: Time.zone.now + 30.days
          FactoryBot.create :offer # additional normal offer
          Offer.seasonal.must_equal [seasonal_offer]
        end
      end
    end

    describe 'observers' do
      describe 'after create' do
        it 'should try to set a creator' do
          new_offer = FactoryBot.create :offer, created_by: nil
          assert_not_nil new_offer.created_by
        end
      end
    end

    describe 'partial_dup' do
      it 'should correctly duplicate an offer' do
        offer = FactoryBot.create :offer, :approved, :with_location
        duplicate = offer.partial_dup
        assert_nil duplicate.created_by
        duplicate.location.must_equal offer.location
        # duplicate.organizations.must_equal offer.organizations
        duplicate.openings.must_equal offer.openings
        duplicate.section.must_equal offer.section
        duplicate.divisions.must_equal offer.divisions
        duplicate.language_filters.must_equal offer.language_filters
        duplicate.websites.must_equal offer.websites
        duplicate.contact_people.must_equal offer.contact_people
        duplicate.tags.must_equal offer.tags
        assert_nil duplicate.area
        duplicate.aasm_state.must_equal 'initialized'
      end
    end

    describe '_residency_status_filters' do
      it 'should correctly return all residence_status identifiers' do
        offer = FactoryBot.create :offer, :approved, section_id: 2
        TargetAudienceFiltersOffer.create!(
          offer_id: offer.id, target_audience_filter_id: 4,
          residency_status: 'with_deportation_decision',
          age_from: 14, age_to: 21
        )
        offer._residency_status_filters.must_equal %w[with_deportation_decision]
        # add another one => both must be returned
        TargetAudienceFiltersOffer.create!(
          offer_id: offer.id, target_audience_filter_id: 4,
          residency_status: 'with_a_residence_permit',
          age_from: 14, age_to: 21
        )
        offer._residency_status_filters.must_equal %w[
          with_deportation_decision with_a_residence_permit
        ]
        # add same residence_status again => result must be uniq
        TargetAudienceFiltersOffer.create!(
          offer_id: offer.id, target_audience_filter_id: 3,
          residency_status: 'with_a_residence_permit',
          age_from: 14, age_to: 22
        )
        offer._residency_status_filters.must_equal %w[
          with_deportation_decision with_a_residence_permit
        ]
      end
    end

    describe '#remote_or_belongs_to_informable_city?' do
      it 'must be true for a personal offer with all_done organization' do
        location_offer = FactoryBot.create :offer, :approved, :with_location
        location_offer.organizations.first.update_columns aasm_state: 'all_done'
        location_offer.remote_or_belongs_to_informable_city?.must_equal true
      end

      it 'must be false for a personal offer with approved organization' do
        location_offer = FactoryBot.create :offer, :approved, :with_location
        location_offer.location.city = City.new(name: 'Bielefeld')
        location_offer.organizations.first.update_columns aasm_state: 'approved'
        location_offer.remote_or_belongs_to_informable_city?.must_equal false
      end

      it 'must be true for a remote offer with a city-area' do
        remote_offer = FactoryBot.create :offer, :approved, encounter: 'chat'
        remote_offer.area = FactoryBot.create :area, name: 'Berlin'
        remote_offer.organizations.first.update_columns aasm_state: 'all_done'
        remote_offer.remote_or_belongs_to_informable_city?.must_equal true
      end

      it 'must be true for a remote offer with area that does'\
         ' not match a city' do
        remote_offer = FactoryBot.create :offer, :approved, encounter: 'chat'
        remote_offer.area = FactoryBot.create :area, name: 'NotACity'
        remote_offer.organizations.first.update_columns aasm_state: 'approved'
        remote_offer.remote_or_belongs_to_informable_city?.must_equal true
      end
    end

    describe '#editable?' do
      it 'must return true for EDITABLE_IN_STATES states' do
        states = Offer.aasm.states.map(&:name)
        states_returning_true = states.select do |state|
          Offer.new(aasm_state: state).editable?
        end.map(&:to_s).sort
        Offer::EDITABLE_IN_STATES.sort.must_equal states_returning_true
      end
    end

    describe 'State Machine' do
      describe '#different_actor?' do
        it 'should return true when created_by differs from current_actor' do
          offer.created_by = 99
          offer.send(:different_actor?).must_equal true
        end

        it 'should return false when created_by is nil' do
          offer.send(:different_actor?).must_equal false
        end

        it 'should return false when current_actor is nil' do
          offer.created_by = 1
          Creator::Twin.any_instance.stubs(:current_actor).returns(nil)
          offer.send(:different_actor?).must_equal false
        end
      end

      describe '#LogicVersion' do
        it 'should have the latest LogicVersion after :complete and :approve' do
          offer.created_by = 99
          offer.aasm_state = 'initialized'
          new_logic1 = LogicVersion.create(name: 'Foo', version: 200)
          offer.send(:complete)
          offer.logic_version_id.must_equal new_logic1.id
          new_logic2 = LogicVersion.create(name: 'Bar', version: 201)
          offer.send(:start_approval_process)
          offer.send(:approve)
          offer.logic_version_id.must_equal new_logic2.id
        end
      end

      describe 'seasonal offers' do
        it 'should transition to seasonal_pending for a future start_date' do
          basicOffer.update_columns aasm_state: 'approval_process',
                                    starts_at: Time.zone.now + 1.day,
                                    ends_at: Time.zone.now + 30.days
          basicOffer.must_be :valid?
          basicOffer.send(:approve)
          basicOffer.must_be :seasonal_pending?
        end

        it 'should transition to approved for a past start_date' do
          basicOffer.update_columns aasm_state: 'approval_process',
                                    starts_at: Time.zone.now - 1.day,
                                    ends_at: Time.zone.now + 30.days
          basicOffer.must_be :valid?
          basicOffer.send(:approve)
          basicOffer.must_be :approved?
        end
      end

      describe '#seasonal_offer_not_yet_to_be_approved' do
        it 'should be false without a start date' do
          basicOffer.starts_at = nil
          basicOffer.send(
            :seasonal_offer_not_yet_to_be_approved?
          ).must_equal false
        end

        it 'should be false with a start date in the past' do
          basicOffer.starts_at = Time.zone.now - 1.day
          basicOffer.send(
            :seasonal_offer_not_yet_to_be_approved?
          ).must_equal false
        end

        it 'should be true with a start date in the future' do
          basicOffer.starts_at = Time.zone.now + 1.day
          basicOffer.send(
            :seasonal_offer_not_yet_to_be_approved?
          ).must_equal true
        end
      end
    end

    describe 'translation' do
      it 'should get translated name, description, and old_next_steps' do
        Offer.any_instance.stubs(:generate_translations!)
        offer = FactoryBot.create :offer
        offer.translations <<
          FactoryBot.create(:offer_translation, locale: :de, name: 'de name',
                                                description: 'de desc',
                                                old_next_steps: 'de next')
        offer.translations <<
          FactoryBot.create(:offer_translation, locale: :en, name: 'en name',
                                                description: 'en desc',
                                                old_next_steps: 'en next')
        old_locale = I18n.locale

        I18n.locale = :de
        offer.translated_name.must_equal 'de name'
        offer.translated_description.must_equal 'de desc'
        offer.translated_old_next_steps.must_equal 'de next'

        I18n.locale = :en
        offer = Offer.find(offer.id) # clear memoization
        offer.translated_name.must_equal 'en name'
        offer.translated_description.must_equal 'en desc'
        offer.translated_old_next_steps.must_equal 'en next'

        I18n.locale = old_locale
      end
    end
  end
end
