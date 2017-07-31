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
          approved_offer = FactoryGirl.create :offer, :approved
          expired = FactoryGirl.create :offer, aasm_state: 'expired'
          Offer.visible_in_frontend.to_a.include?(approved_offer).must_equal true
          Offer.visible_in_frontend.to_a.include?(expired).must_equal true
        end

        it 'excludes offers that are not approved or expired' do
          offer = FactoryGirl.create :offer, aasm_state: 'completed'
          Offer.visible_in_frontend.to_a.include?(offer).must_equal false
          offer = FactoryGirl.create :offer, aasm_state: 'initialized'
          Offer.visible_in_frontend.to_a.include?(offer).must_equal false
          offer = FactoryGirl.create :offer, aasm_state: 'paused'
          Offer.visible_in_frontend.to_a.include?(offer).must_equal false
          offer = FactoryGirl.create :offer, aasm_state: 'internal_feedback'
          Offer.visible_in_frontend.to_a.include?(offer).must_equal false
          offer = FactoryGirl.create :offer, aasm_state: 'organization_deactivated'
          Offer.visible_in_frontend.to_a.include?(offer).must_equal false
          offer = FactoryGirl.create :offer, aasm_state: 'website_unreachable'
          Offer.visible_in_frontend.to_a.include?(offer).must_equal false
        end
      end

      describe 'seasonal' do
        it 'should correctly retrieve only seasonal offers with seasonal scope' do
          seasonal_offer = FactoryGirl.create :offer,
                                              starts_at: Time.zone.now - 30.days,
                                              expires_at: Time.zone.now + 30.days
          FactoryGirl.create :offer # additional normal offer
          Offer.seasonal.must_equal [seasonal_offer]
        end
      end
    end

    describe 'observers' do
      describe 'after create' do
        it 'should try to set a creator' do
          new_offer = FactoryGirl.create :offer, created_by: nil
          assert_not_nil new_offer.created_by
        end
      end
    end

    describe 'partial_dup' do
      it 'should correctly duplicate an offer' do
        offer = FactoryGirl.create :offer, :approved, :with_location
        duplicate = offer.partial_dup
        assert_nil duplicate.created_by
        duplicate.location.must_equal offer.location
        # duplicate.organizations.must_equal offer.organizations
        duplicate.openings.must_equal offer.openings
        duplicate.categories.must_equal offer.categories
        duplicate.section.must_equal offer.section
        duplicate.split_base.must_equal offer.split_base
        duplicate.language_filters.must_equal offer.language_filters
        duplicate.websites.must_equal offer.websites
        duplicate.contact_people.must_equal offer.contact_people
        duplicate.tags.must_equal offer.tags
        assert_nil duplicate.area
        duplicate.aasm_state.must_equal 'initialized'
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
                                    expires_at: Time.zone.now + 30.days
          basicOffer.must_be :valid?
          basicOffer.send(:approve)
          basicOffer.must_be :seasonal_pending?
        end

        it 'should transition to approved for a past start_date' do
          basicOffer.update_columns aasm_state: 'approval_process',
                                    starts_at: Time.zone.now - 1.day,
                                    expires_at: Time.zone.now + 30.days
          basicOffer.must_be :valid?
          basicOffer.send(:approve)
          basicOffer.must_be :approved?
        end
      end

      describe '#seasonal_offer_not_yet_to_be_approved' do
        it 'should be false without a start date' do
          basicOffer.starts_at = nil
          basicOffer.send(:seasonal_offer_not_yet_to_be_approved?).must_equal false
        end

        it 'should be false with a start date in the past' do
          basicOffer.starts_at = Time.zone.now - 1.day
          basicOffer.send(:seasonal_offer_not_yet_to_be_approved?).must_equal false
        end

        it 'should be true with a start date in the future' do
          basicOffer.starts_at = Time.zone.now + 1.day
          basicOffer.send(:seasonal_offer_not_yet_to_be_approved?).must_equal true
        end
      end
    end

    describe 'translation' do
      it 'should get translated name, description, and old_next_steps' do
        Offer.any_instance.stubs(:generate_translations!)
        offer = FactoryGirl.create :offer
        offer.translations <<
          FactoryGirl.create(:offer_translation, locale: :de, name: 'de name',
                                                 description: 'de desc',
                                                 old_next_steps: 'de next')
        offer.translations <<
          FactoryGirl.create(:offer_translation, locale: :en, name: 'en name',
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

      it 'should always get de translation, others on completion and change' do
        # Setup
        new_offer = FactoryGirl.create(:offer)
        new_offer.translations.count.must_equal 1
        new_offer.translations.first.locale.must_equal 'de'
        new_offer.aasm_state.must_equal 'initialized'

        # Changing things on an initialized offer doesn't change translations
        assert_nil new_offer.reload.name_ar
        new_offer.name = 'changing name, wont update translation'
        new_offer.save!
        new_offer.run_callbacks(:commit) # Hotfix: force commit callback
        new_offer.translations.count.must_equal 1
        assert_nil new_offer.reload.name_ar

        # completion does not generate translations
        new_offer.complete!
        new_offer.run_callbacks(:commit) # Hotfix: force commit callback
        new_offer.translations.count.must_equal 1

        # approval generates all translations initially
        new_offer.start_approval_process!
        new_offer.approve!
        new_offer.translations.count.must_equal I18n.available_locales.count
        new_offer.reload.name_ar.must_equal 'GET READY FOR CANADA'

        # Now changes to the model change the corresponding translated fields
        EasyTranslate.translated_with 'CHANGED' do
          new_offer.reload.name_ar.must_equal 'GET READY FOR CANADA'
          new_offer.description_ar.must_equal 'GET READY FOR CANADA'
          new_offer.name = 'changing name, should update translation'
          new_offer.save!
          new_offer.run_callbacks(:commit) # Hotfix: force commit callback
          new_offer.reload.name_ar.must_equal 'CHANGED'
          new_offer.description_ar.must_equal 'GET READY FOR CANADA'
        end
      end

      it 'should update an existing translation only when the field changed' do
        # Setup
        new_offer = FactoryGirl.create(:offer)
        new_offer.translations.count.must_equal 1
        new_offer.translations.first.locale.must_equal 'de'
        new_offer.aasm_state.must_equal 'initialized'
        new_offer.complete!
        new_offer.translations.count.must_equal 1
        new_offer.start_approval_process!
        new_offer.approve!
        new_offer.translations.count.must_equal I18n.available_locales.count
        new_offer.reload.name_ar.must_equal 'GET READY FOR CANADA'

        # Now changes to the model change the corresponding translated fields
        EasyTranslate.translated_with 'CHANGED' do
          new_offer.reload.name_ar.must_equal 'GET READY FOR CANADA'
          new_offer.description_ar.must_equal 'GET READY FOR CANADA'
          # changing untranslated field => translations must stay the same
          new_offer.expires_at = Date.tomorrow
          new_offer.save!
          new_offer.run_callbacks(:commit) # Hotfix: force commit callback
          new_offer.reload.name_ar.must_equal 'GET READY FOR CANADA'
          new_offer.reload.description_ar.must_equal 'GET READY FOR CANADA'
          new_offer.name = 'changing name, should update translation'
          new_offer.save!
          new_offer.run_callbacks(:commit) # Hotfix: force commit callback
          new_offer.translations.where(locale: 'ar').first.name.must_equal 'CHANGED'
          new_offer.reload.name_ar.must_equal 'CHANGED'
          new_offer.reload.description_ar.must_equal 'GET READY FOR CANADA'
        end
      end

      it 'wont update changed fields for manually translated locales when the'\
         ' existing translation came from a human' do
        # Setup: Offer is first created
        new_offer = FactoryGirl.create(:offer)
        new_offer.complete!
        new_offer.translations.count.must_equal 1
        new_offer.start_approval_process!
        new_offer.approve!
        new_offer.translations.count.must_equal I18n.available_locales.count

        # Setup: A human edits the arabic translation and en
        ar_translation = new_offer.translations.find_by(locale: :ar)
        ar_translation.update_columns name: 'MANUAL EDIT', source: 'researcher'

        # Now changes to the model change the corresponding translated fields
        EasyTranslate.translated_with 'CHANGED' do
          new_offer.reload.name_ar.must_equal 'MANUAL EDIT'
          new_offer.description_ar.must_equal 'GET READY FOR CANADA'
          new_offer.name_ru.must_equal 'GET READY FOR CANADA'
          new_offer.name = 'changing name, should update some translations'
          new_offer.save!
          new_offer.run_callbacks(:commit) # Hotfix: force commit callback
          new_offer.reload.name_ar.must_equal 'MANUAL EDIT'
          new_offer.description_ar.must_equal 'GET READY FOR CANADA'
          new_offer.name_ru.must_equal 'CHANGED'
          ar_translation.reload.possibly_outdated?.must_equal true
        end
      end
    end
  end
end
