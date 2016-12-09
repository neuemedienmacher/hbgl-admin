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
        assert_nil duplicate.created_by
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
        offer.name.must_equal 'de name'
        offer.description.must_equal 'de desc'
        offer.old_next_steps.must_equal 'de next'

        I18n.locale = :en
        offer = Offer.find(offer.id) # clear memoization
        offer.name.must_equal 'en name'
        offer.description.must_equal 'en desc'
        offer.old_next_steps.must_equal 'en next'

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
        new_offer.translations.count.must_equal 1
        assert_nil new_offer.reload.name_ar

        # completion does not generate translations
        new_offer.complete!
        new_offer.translations.count.must_equal 1

        # approval generates all translations initially
        new_offer.start_approval_process!
        new_offer.approve!
        new_offer.translations.count.must_equal I18n.available_locales.count

        # Now changes to the model change the corresponding translated fields

        EasyTranslate.translated_with 'CHANGED' do
          new_offer.reload.name_ar.must_equal 'GET READY FOR CANADA'
          new_offer.description_ar.must_equal 'GET READY FOR CANADA'
          new_offer.name = 'changing name, should update translation'
          new_offer.save!
          new_offer.reload.name_ar.must_equal 'CHANGED'
          new_offer.description_ar.must_equal 'GET READY FOR CANADA'
        end
      end

      it 'should update an existing translation only when the field changed' do
        # Setup
        new_offer = FactoryGirl.create(:offer)
        new_offer.complete!
        new_offer.translations.count.must_equal 1
        new_offer.start_approval_process!
        new_offer.approve!
        new_offer.translations.count.must_equal I18n.available_locales.count

        # Now changes to the model change the corresponding translated fields
        EasyTranslate.translated_with 'CHANGED' do
          new_offer.reload.name_ar.must_equal 'GET READY FOR CANADA'
          new_offer.description_ar.must_equal 'GET READY FOR CANADA'
          # changing untranslated field => translations must stay the same
          new_offer.age_from = 0
          new_offer.save!
          new_offer.reload.name_ar.must_equal 'GET READY FOR CANADA'
          new_offer.reload.description_ar.must_equal 'GET READY FOR CANADA'
          new_offer.name = 'changing name, should update translation'
          new_offer.save!
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
          new_offer.reload.name_ar.must_equal 'MANUAL EDIT'
          new_offer.description_ar.must_equal 'GET READY FOR CANADA'
          new_offer.name_ru.must_equal 'CHANGED'
          ar_translation.reload.possibly_outdated?.must_equal true
        end
      end
    end
  end
end
