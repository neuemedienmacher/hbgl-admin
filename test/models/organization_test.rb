# frozen_string_literal: true
require_relative '../test_helper'

describe Organization do
  subject { organization }

  describe 'partial_dup' do
    it 'should correctly duplicate an organization' do
      organization = FactoryGirl.create :organization, :approved
      duplicate = organization.partial_dup
      assert_nil duplicate.name
      assert_nil duplicate.founded
      duplicate.aasm_state.must_equal 'initialized'
    end
  end

  describe 'State Machine' do
    it 'should transition from approved to all_done and call mailings method' do
      organization = FactoryGirl.create :organization, aasm_state: 'approved'
      organization.expects(:apply_mailings_logic!).once
      organization.mark_as_done!
      organization.reload.must_be :all_done?
    end
  end

  describe '#apply_mailings_logic!' do
    it 'should call AsanaCommunicator for big_player-orga and dont change mailings' do
      organization = FactoryGirl.create :organization, :approved,
                                        mailings: 'disabled'
      # fake big organization (more than 9 locations)
      10.times do
        new_location = FactoryGirl.create :location
        organization.locations << new_location
      end
      organization.big_player?.must_equal true
      AsanaCommunicator.any_instance.expects(:create_big_orga_is_done_task)
                       .with(organization).once
      organization.send(:apply_mailings_logic!)
      organization.reload.mailings.must_equal 'big_player'
    end

    it 'wont create Asana Task but change mailings for small orga' do
      organization = FactoryGirl.create :organization, :approved,
                                        mailings: 'disabled'
      AsanaCommunicator.any_instance.expects(:create_big_orga_is_done_task).never
      organization.send(:apply_mailings_logic!)
      organization.reload.mailings.must_equal 'enabled'
    end

    it 'wont do anything for big_player organizations' do
      organization = FactoryGirl.create :organization, :approved,
                                        mailings: 'big_player'
      AsanaCommunicator.any_instance.expects(:create_big_orga_is_done_task).never
      organization.send(:apply_mailings_logic!)
      organization.reload.mailings.must_equal 'big_player'
    end

    it 'wont do anything for force_disabled organization' do
      organization = FactoryGirl.create :organization, :approved,
                                        mailings: 'force_disabled'
      AsanaCommunicator.any_instance.expects(:create_big_orga_is_done_task).never
      organization.send(:apply_mailings_logic!)
      organization.reload.mailings.must_equal 'force_disabled'
    end
  end

  describe '#big_player?' do
    it 'should be false for small organizations' do
      organization = FactoryGirl.create :organization, :approved
      organization.big_player?.must_equal false
    end

    it 'should be true for specific name and above location threshold' do
      organization = FactoryGirl.create :organization, :approved,
                                        name: 'AWO Nordrhein-Westfalen'
      # false, because location threshold is not reached with one location
      # organization.locations << (FactoryGirl.create :location)
      organization.big_player?.must_equal false
      # one more location => threshold reached
      organization.locations << (FactoryGirl.create :location)
      # but only one offer, that should not be enough
      organization.offers << (FactoryGirl.create :offer, :approved,
                                                 :with_location)

      organization.big_player?.must_equal false
      # adding 9 more and it should work
      9.times do
        organization.offers << (FactoryGirl.create :offer, :approved,
                                                   :with_location)
      end
      organization.big_player?.must_equal true
    end

    it 'should be true for big organizations' do
      organization = FactoryGirl.create :organization, :approved
      10.times do
        new_location = FactoryGirl.create :location
        organization.locations << new_location
      end
      organization.big_player?.must_equal true
    end
  end

  describe 'translation' do
    it 'should always get de translation, others only on completion and change' do
      new_orga = FactoryGirl.create(:organization)
      new_orga.translations.count.must_equal 1 # only :de
      new_orga.translations.first.locale.must_equal 'de'
      new_orga.aasm_state.must_equal 'initialized'

      # Changing things on an initialized offer doesn't change translations
      assert_nil new_orga.reload.description_ar
      new_orga.description = 'changing description, wont update translation'
      new_orga.save!
      new_orga.translations.count.must_equal 1
      assert_nil new_orga.reload.description_ar

      # Completion does not generate translations
      new_orga.complete!
      new_orga.translations.count.must_equal 1

      # Approval generates all translations initially
      new_orga.start_approval_process!
      new_orga.approve!
      new_orga.translations.count.must_equal I18n.available_locales.count

      # Now changes to the model change the corresponding translated fields
      EasyTranslate.translated_with 'CHANGED' do
        new_orga.description_ar.must_equal 'GET READY FOR CANADA'
        new_orga.description = 'changing description, should update translation'
        new_orga.save!
        new_orga.reload.description_ar.must_equal 'CHANGED'
      end
    end

    it 'should update an existing translation only when the field changed' do
      # Setup
      new_orga = FactoryGirl.create(:organization)
      new_orga.complete!
      new_orga.translations.count.must_equal 1
      new_orga.start_approval_process!
      new_orga.approve!
      new_orga.translations.count.must_equal I18n.available_locales.count

      # Now changes to the model change the corresponding translated fields
      EasyTranslate.translated_with 'CHANGED' do
        new_orga.description_ar.must_equal 'GET READY FOR CANADA'
        # changing untranslated field => translations must stay the same
        new_orga.mailings = 'enabled'
        new_orga.save!
        new_orga.reload.description_ar.must_equal 'GET READY FOR CANADA'
        new_orga.description = 'changing descr, should update translation'
        new_orga.save!
        new_orga.reload.description_ar.must_equal 'CHANGED'
      end
    end
  end
end
