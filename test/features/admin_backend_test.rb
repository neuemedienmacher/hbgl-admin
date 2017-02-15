# encoding: UTF-8
# frozen_string_literal: true
require_relative '../test_helper'
include Warden::Test::Helpers

feature 'Admin Backend' do
  let(:researcher) { FactoryGirl.create :researcher }
  let(:superuser) { FactoryGirl.create :super }

  describe 'as researcher' do
    before { login_as researcher }

    scenario 'Administrating Offers' do
      visit rails_admin_path

      click_link 'Angebote', match: :first
      click_link 'Neu hinzufügen'

      assert_difference 'Offer.count', 1 do
        select 'Family', from: 'offer_section_filter_ids'
        fill_in 'offer_name', with: 'testangebot'
        fill_in 'offer_description', with: 'testdescription'
        fill_in 'offer_age_from', with: 0
        fill_in 'offer_age_to', with: 17
        select 'basicNextStep', from: 'offer_next_step_ids'
        select 'Personal', from: 'offer_encounter'
        select 'basicLocation', from: 'offer_location_id'
        select 'foobar', from: 'offer_organization_ids'
        select 'English', from: 'offer_language_filter_ids'
        select 'Bekannte', from: 'offer_target_audience_filter_ids'
        select 'basicSplitBaseTitle', from: 'offer_split_base_id'

        click_button 'Speichern'
        page.must_have_content 'Angebot wurde erfolgreich hinzugefügt'
        page.must_have_content 'testangebot'
      end
    end

    scenario 'Administrating Organizations' do
      visit rails_admin_path

      click_link 'Organisationen', match: :first
      click_link 'Neu hinzufügen'

      assert_difference 'Organization.count', 1 do
        fill_in 'organization_name', with: 'testorganisation'
        fill_in 'organization_description', with: 'testdescription'
        select 'e.V.', from: 'organization_legal_form'
        select 'basicLocation', from: 'organization_location_ids'
        select 'Diakonie', from: 'organization_umbrella_filter_ids'
        check 'organization_accredited_institution'

        click_button 'Speichern'
        page.must_have_content 'testorganisation'
        page.must_have_content 'Organisation wurde erfolgreich hinzugefügt'
        page.must_have_content researcher.email
      end
    end

    scenario 'Try to create organization with/out hq-location' do
      orga = organizations(:basic)
      location = FactoryGirl.create :location, :hq, organization: orga
      orga.update_columns aasm_state: 'initialized', created_by: researcher.id

      visit rails_admin_path
      click_link 'Organisationen', match: :first
      click_link 'Bearbeiten', match: :first

      click_link 'Als komplett markieren', match: :first
      page.must_have_content 'Zustandsänderung konnte nicht erfolgen'
      page.must_have_content 'nicht valide'

      # 1: With two hq locations
      click_button 'Speichern'
      page.must_have_content 'Es muss genau eine HQ-Location zugeordnet werden'

      # 2: With non-hq locations
      locations(:basic).update_column :hq, false
      location.update_column :hq, false
      click_button 'Speichern'
      page.must_have_content 'Es muss genau eine HQ-Location zugeordnet werden'

      # 3: With one hq location
      location.update_column :hq, true
      click_button 'Speichern'
      page.must_have_content 'Organisation wurde erfolgreich aktualisiert'

      # complete works
      click_link 'Als komplett markieren', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich.'

      click_link 'Approval starten', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'

      # There is no approve link as same user
      # page.wont_have_link 'Freischalten'
      # TODO: change this!
      page.must_have_link 'Freischalten'

      # Approval works as different user
      login_as superuser
      visit current_path
      page.must_have_link 'Freischalten'
      click_link 'Freischalten', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
    end

    scenario 'Deactivate Organization' do
      orga = organizations(:basic)
      split_base = FactoryGirl.create(:split_base, organization: orga)
      FactoryGirl.create :offer, organization: orga, split_base: split_base,
                                 aasm_state: :completed
      FactoryGirl.create :offer, organization: orga, split_base: split_base,
                                 aasm_state: :internal_feedback

      visit rails_admin_path
      click_link 'Organisationen', match: :first
      click_link 'Bearbeiten', match: :first

      # Deactivation button click: deactivates orga and all its approved offers

      orga.visible_in_frontend?.must_equal true
      orga.offers.select(:aasm_state).map(&:aasm_state).must_equal(
        %w(approved completed internal_feedback)
      )

      click_link 'Deaktivieren (External Feedback)', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'

      orga.reload.must_be :external_feedback?
      orga.offers.select(:aasm_state).map(&:aasm_state).must_equal(
        %w(organization_deactivated completed internal_feedback)
      )

      # Approve button click: reactivates orga and all its approved offers

      click_link 'Freischalten (Comms-Only)', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'

      orga.reload.must_be :approved?
      orga.offers.select(:aasm_state).map(&:aasm_state).must_equal(
        %w(approved completed internal_feedback)
      )
    end

    scenario 'Set offer to dozing and reinitialize it afterwards' do
      orga = organizations(:basic)
      split_base = FactoryGirl.create(:split_base, organization: orga)
      offer = FactoryGirl.create :offer, organization: orga,
                                         split_base: split_base

      visit rails_admin_path
      click_link 'Angebote', match: :first
      click_link 'Bearbeiten', match: :first

      offer.must_be :initialized?

      click_link 'Schlafen legen', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :dozing?

      click_link 'Re-Initialisieren', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :initialized?
    end

    scenario 'under_construction_pre state should work correctly on offer' do
      orga = organizations(:basic)
      split_base = FactoryGirl.create(:split_base, organization: orga)
      offer = FactoryGirl.create :offer, organization: orga,
                                         split_base: split_base

      visit rails_admin_path
      click_link 'Angebote', match: :first
      click_link 'Bearbeiten', match: :first

      offer.must_be :initialized?

      click_link 'Webseite im Aufbau', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :under_construction_pre?

      click_link 'Re-Initialisieren', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :initialized?
    end

    scenario 'under_construction_post state should work correctly on offer' do
      orga = organizations(:basic)
      split_base = FactoryGirl.create(:split_base, organization: orga)
      offer = FactoryGirl.create :offer, :approved, organization: orga,
                                                    split_base: split_base

      visit rails_admin_path
      click_link 'Angebote', match: :first
      click_link 'Bearbeiten', match: :first

      offer.must_be :approved?

      click_link 'Webseite im Aufbau', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :under_construction_post?

      click_link 'Checkup starten', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :checkup_process?

      click_link 'Freischalten', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :approved?
    end

    scenario 'create a seasonal pending offer' do
      orga = organizations(:basic)
      split_base = FactoryGirl.create(:split_base, organization: orga)
      offer = FactoryGirl.create :offer, organization: orga,
                                         split_base: split_base,
                                         starts_at: (Time.zone.now + 1.day)

      visit rails_admin_path
      click_link 'Angebote', match: :first
      click_link 'Bearbeiten', match: :first

      offer.must_be :initialized?

      click_link 'Als komplett markieren', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :completed?

      click_link 'Approval starten', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :approval_process?

      click_link 'Freischalten', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :seasonal_pending?

      # simulate worker
      offer.update_columns starts_at: (Time.zone.now - 1.day), aasm_state: 'approved'
      offer.reload.must_be :approved?
      offer.reload.valid?.must_equal true
    end

    scenario 'checkup_process must be possible for invalid offers' do
      orga = organizations(:basic)
      split_base = FactoryGirl.create(:split_base, organization: orga)
      offer = FactoryGirl.create :offer, :approved, organization: orga,
                                                    split_base: split_base

      offer.valid?.must_equal true
      visit rails_admin_path
      click_link 'Angebote', match: :first
      click_link 'Bearbeiten', match: :first

      # simulate expired offer in other deactivation state (offer invalid)
      offer.update_columns aasm_state: 'internal_feedback', expires_at: Time.zone.now - 1.day
      offer.valid?.must_equal false

      page.must_have_link 'Deaktivieren (External Feedback)'
      page.must_have_link 'Checkup starten'

      # transition to other state than 'checkup_process' is not allowed
      click_link 'Deaktivieren (External Feedback)', match: :first
      page.must_have_content 'Zustandsänderung konnte nicht erfolgen'
      page.must_have_content 'nicht valide'
      offer.reload.must_be :internal_feedback?

      # transition to other 'checkup_process' works
      click_link 'Checkup starten', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :checkup_process?
    end

    scenario 'deactivate seasonal_pending offer and reactivate it afterwards' do
      orga = organizations(:basic)
      split_base = FactoryGirl.create(:split_base, organization: orga)
      offer = FactoryGirl.create :offer, :approved, organization: orga,
                                                    split_base: split_base,
                                                    starts_at: (Time.zone.now - 1.day)

      offer.aasm_state = 'paused'
      offer.must_be :paused?

      visit rails_admin_path
      click_link 'Angebote', match: :first
      click_link 'Bearbeiten', match: :first

      click_link 'Checkup starten', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :checkup_process?

      click_link 'Freischalten', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :approved?
    end

    scenario 'Deactivate Organization and then set to under_construction' do
      orga = organizations(:basic)
      split_base = FactoryGirl.create(:split_base, organization: orga)
      FactoryGirl.create :offer, organization: orga, split_base: split_base,
                                 aasm_state: :completed
      FactoryGirl.create :offer, organization: orga, split_base: split_base,
                                 aasm_state: :internal_feedback

      visit rails_admin_path
      click_link 'Organisationen', match: :first
      click_link 'Bearbeiten', match: :first

      # Deactivation button click: deactivates orga and all its approved offers
      orga.visible_in_frontend?.must_equal true
      orga.offers.select(:aasm_state).map(&:aasm_state).must_equal(
        %w(approved completed internal_feedback)
      )

      click_link 'Deaktivieren (External Feedback)', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'

      orga.reload.must_be :external_feedback?
      orga.offers.select(:aasm_state).map(&:aasm_state).must_equal(
        %w(organization_deactivated completed internal_feedback)
      )

      click_link 'Webseite im Aufbau', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'

      orga.reload.must_be :under_construction_post?
      orga.offers.select(:aasm_state).map(&:aasm_state).must_equal(
        %w(organization_deactivated completed internal_feedback )
      )

      # make last offer invalid => should not be approved or in checkup but
      # remain in its last deactivation-state
      orga.offers.last.update_columns expires_at: Time.zone.now - 1.day

      # Approve button click: reactivates orga and all its approved offers
      click_link 'Freischalten (Comms-Only)', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'

      orga.reload.must_be :approved?
      orga.offers.select(:aasm_state).map(&:aasm_state).must_equal(
        %w(approved completed internal_feedback)
      )
    end

    scenario 'Try to create offer with errors' do
      location = FactoryGirl.create(:location, name: 'testname')
      contact_person = FactoryGirl.create :contact_person

      visit rails_admin_path

      click_link 'Angebote', match: :first
      click_link 'Neu hinzufügen'

      fill_in 'offer_name', with: 'testangebot'
      fill_in 'offer_description', with: 'testdescription'
      select 'basicNextStep', from: 'offer_next_step_ids'
      select 'Personal', from: 'offer_encounter'
      select location.name, from: 'offer_location_id'
      select 'foobar', from: 'offer_organization_ids'
      select 'basicSplitBaseTitle', from: 'offer_split_base_id'

      click_button 'Speichern und bearbeiten'

      # Orga/Location mismatch wasn't tested yet
      page.wont_have_content(
        'Location muss zu der unten angegebenen Organisation gehören.'
      )
      page.wont_have_content(
        'Organizations muss die des angegebenen Standorts beinhalten.'
      )

      fill_in 'offer_age_from', with: -1
      fill_in 'offer_age_to', with: 19
      click_button 'Speichern und bearbeiten'

      page.wont_have_content 'Age from muss ausgefüllt werden'
      page.wont_have_content 'Age to muss ausgefüllt werden'

      # Age filter needs correct lower bounds
      page.must_have_content 'Age from muss größer oder gleich 0 sein'
      fill_in 'offer_age_from', with: 0
      fill_in 'offer_age_to', with: 100
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'Age from muss größer oder gleich 0 sein'

      # Age filter needs correct upper bounds
      page.must_have_content 'Age to muss kleiner oder gleich 99 sein'
      fill_in 'offer_age_from', with: 9
      fill_in 'offer_age_to', with: 8
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'Age to muss kleiner oder gleich 99 sein'

      # Age Filter in correct range, but from is higher than to
      page.must_have_content 'Age from darf nicht größer sein als Age to'

      # Age Filter correct, but wrong contact_person chosen
      fill_in 'offer_age_from', with: 0
      fill_in 'offer_age_to', with: 17
      select contact_person.display_name, from: 'offer_contact_person_ids'
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'Age from darf nicht größer sein als Age to'
      page.must_have_content 'Contact people müssen alle zu einer der'\
                             ' ausgewählten Organisationen gehören oder als'\
                             ' SPoC markiert sein'

      # contact_person becomes SPoC, still needs target_audience
      contact_person.update_column :spoc, true
      select 'Family', from: 'offer_section_filter_ids'
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'Contact people müssen alle zu einer der'\
                             ' ausgewählten Organisationen gehören oder als'\
                             ' SPoC markiert sein'
      page.must_have_content 'benötigt mindestens einen Target Audience Filter'

      # target audience selected, needs language filters
      select 'Bekannte', from: 'offer_target_audience_filter_ids'
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'benötigt mindestens einen Target Audience Filter'
      page.must_have_content 'Language filters benötigt mindestens einen'\
                             ' Sprachfilter'

      # language filter selected, it saves
      select 'English', from: 'offer_language_filter_ids'
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'Language filters benötigt mindestens einen'\
                             ' Sprachfilter'
      page.must_have_content 'Angebot wurde erfolgreich hinzugefügt'

      ## Test Update validations

      # Try to complete, doesnt work
      click_link 'Als komplett markieren', match: :first
      page.must_have_content 'Zustandsänderung konnte nicht erfolgen'
      page.must_have_content 'nicht valide'

      # See what the issue is (orga/location mismatch)
      click_button 'Speichern und bearbeiten'
      page.must_have_content 'Angebot wurde nicht aktualisiert'
      page.must_have_content(
        'Location muss zu der unten angegebenen Organisation gehören.'
      )
      page.must_have_content(
        'Organizations muss die des angegebenen Standorts beinhalten.'
      )

      # Fix Orga/Location mismatch, still needs categories
      location.update_column :organization_id, 1
      click_button 'Speichern und bearbeiten'
      page.wont_have_content(
        'Location muss zu der unten angegebenen Organisation gehören.'
      )
      page.wont_have_content(
        'Organizations muss die des angegebenen Standorts beinhalten.'
      )
      page.must_have_content "benötigt mindestens eine 'Family' Kategorie"

      # Fill categories, it saves again
      select 'main1', from: 'offer_category_ids'
      click_button 'Speichern und bearbeiten'
      page.wont_have_content "benötigt mindestens eine 'Family' Kategorie"
      page.must_have_content 'Angebot wurde erfolgreich aktualisiert'

      # Complete works
      click_link 'Als komplett markieren', match: :first
      page.wont_have_content 'Zustandsänderung konnte nicht erfolgen'
      page.must_have_content 'Zustandsänderung war erfolgreich'
    end

    scenario 'Approve offer' do
      orga = organizations(:basic)
      orga.update_column :aasm_state, 'completed'

      # Create incomplete offer
      visit rails_admin_path

      click_link 'Angebote', match: :first
      click_link 'Neu hinzufügen'

      select 'Family', from: 'offer_section_filter_ids'
      fill_in 'offer_name', with: 'testangebot'
      fill_in 'offer_description', with: 'testdescription'
      fill_in 'offer_age_from', with: 0
      fill_in 'offer_age_to', with: 6
      select 'basicNextStep', from: 'offer_next_step_ids'
      select 'Hotline', from: 'offer_encounter'
      select 'basicLocation', from: 'offer_location_id'
      select 'main1', from: 'offer_category_ids'
      select 'basicSplitBaseTitle', from: 'offer_split_base_id'

      ## Test general validations

      # Doesnt save, needs organization
      click_button 'Speichern und bearbeiten'
      page.must_have_content 'Organizations benötigt mindestens eine'\
                             ' Organisation'

      # Organization given, needs an area and no location when remote
      select 'foobar', from: 'offer_organization_ids'
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'Organizations benötigt mindestens eine'\
                             ' Organisation'
      page.must_have_content 'Area muss ausgefüllt werden, wenn Encounter'\
                             ' nicht "personal" ist'
      page.must_have_content 'Location darf keinen Standort haben, wenn'\
                             ' Encounter nicht "personal" ist'

      # area given and no location, needs language filter
      select 'Deutschland', from: 'offer_area_id'
      select '', from: 'offer_location_id'
      click_button 'Speichern'
      page.wont_have_content 'Area muss ausgefüllt werden, wenn Encounter'\
                             ' nicht "personal" ist'
      page.wont_have_content 'Location darf keinen Standort haben, wenn'\
                             ' Encounter nicht "personal" ist'
      page.must_have_content 'Language filters benötigt mindestens einen'\
                             ' Sprachfilter'

      # language filter given, needs target audience
      select 'Deutsch', from: 'offer_language_filter_ids'
      click_button 'Speichern'
      page.wont_have_content 'Language filters benötigt mindestens einen'\
                             ' Sprachfilter'
      page.must_have_content 'benötigt mindestens einen Target Audience Filter'

      # target audience is given, it saves
      select 'Bekannte', from: 'offer_target_audience_filter_ids'
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'benötigt mindestens einen Target Audience Filter'
      page.must_have_content 'Angebot wurde erfolgreich hinzugefügt'
      offer = Offer.last

      click_link 'Als komplett markieren', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :completed?

      click_link 'Approval starten', match: :first
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :approval_process?

      # There is no approve link as same user
      # page.wont_have_link 'Freischalten'
      # TODO: change this!
      page.must_have_link 'Freischalten'

      # Approval as different user
      login_as superuser
      visit current_path
      page.must_have_link 'Freischalten'

      ## Test (after-)approval update validations

      # Try to approve, doesnt work
      offer.reload.valid?.must_equal true
      click_link 'Freischalten', match: :first
      page.must_have_content 'Zustandsänderung konnte nicht erfolgen'
      page.must_have_content 'nicht valide'
      offer.reload.must_be :approval_process?

      # Organization needs to be approved (only validated on approve)
      page.must_have_content 'Organizations darf nur bestätigte Organisationen'\
                             ' beinhalten.'

      # Organization gets approved (via all done), saves
      orga.update_column :aasm_state, 'all_done'
      click_button 'Speichern und bearbeiten'
      page.must_have_content 'Angebot wurde erfolgreich aktualisiert'

      # Approval works
      click_link 'Freischalten', match: :first
      page.wont_have_content 'Organizations darf nur bestätigte Organisationen'\
                             ' beinhalten.'
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :approved?
    end

    # TODO: resurrect this test as soon as there is a uniqueness validation in offer
    # calls partial dup that doesn't end up in an immediately valid offer
    # scenario 'Duplicate offer' do
    #   visit rails_admin_path
    #
    #   click_link 'Angebote', match: :first
    #   click_link 'Duplizieren'
    #
    #   click_button 'Speichern'
    #
    #   page.must_have_content 'Angebot wurde nicht hinzugefuegt' # TODO: ue => &uuml
    # end

    scenario 'Duplicate organization' do
      visit rails_admin_path

      click_link 'Organisationen', match: :first
      click_link 'Duplizieren'
      fill_in 'organization_name', with: 'kopietestname'

      click_button 'Speichern'

      page.must_have_content 'kopietestname'
    end

    scenario 'Duplicate contact_person' do
      FactoryGirl.create :contact_person, spoc: true, offers: [offers(:basic)]

      visit rails_admin_path
      click_link 'Kontaktpersonen', match: :first
      click_link 'Duplizieren', match: :first
      click_button 'Speichern'
      page.wont_have_content 'Kontaktperson wurde nicht hinzugefügt'
      page.must_have_content 'Kontaktperson wurde erfolgreich hinzugefügt'
    end

    scenario 'Duplicate location' do
      visit rails_admin_path
      click_link 'Standorte', match: :first
      click_link 'Duplizieren', match: :first
      click_button 'Speichern'
      page.wont_have_content 'Standort wurde nicht hinzugefügt'
      page.must_have_content 'Standort wurde erfolgreich hinzugefügt'
    end

    scenario 'New category missing section filter' do
      visit rails_admin_path
      click_link 'Problem-Kategorien', match: :first
      click_link 'Neu hinzufügen', match: :first
      fill_in 'category_name_de', with: 'testkategorie'
      click_button 'Speichern'
      page.must_have_content 'benötigt mindestens eine clarat-Welt'
    end

    scenario 'Try to edit existing category and remove section_filters' do
      visit rails_admin_path
      click_link 'Problem-Kategorien', match: :first
      click_link 'Bearbeiten', match: :first
      unselect 'Family', from: 'category_section_filter_ids'
      unselect 'Refugees', from: 'category_section_filter_ids'
      click_button 'Speichern und bearbeiten'
      page.must_have_content 'Kategorie wurde nicht aktualisiert'
      page.must_have_content 'benötigt mindestens eine clarat-Welt'

      select 'Family', from: 'category_section_filter_ids'
      click_button 'Speichern'
      page.must_have_content 'Kategorie wurde erfolgreich aktualisiert'
    end

    # describe 'Dependent Tags' do
    #   before do
    #     @tag = FactoryGirl.create :tag, dependent_tag_count: 1
    #     @dependent = @tag.dependent_categories.first
    #     visit rails_admin_path
    #     click_link 'Angebote', match: :first
    #     click_link 'Bearbeiten'
    #   end
    #
    #   scenario 'Dependent categories get added automatically' do
    #     select @tag.name, from: 'offer_tag_ids'
    #     click_button 'Speichern und bearbeiten'
    #
    #     categories = offers(:basic).reload.categories
    #     categories.must_include @tag
    #     categories.must_include @dependent
    #   end
    #
    #   scenario 'Dependent categories get added only once (dupes get removed)' do
    #     select @tag.name, from: 'offer_tag_ids'
    #     select @dependent.name, from: 'offer_tag_ids'
    #     click_button 'Speichern und bearbeiten'
    #
    #     categories = offers(:basic).reload.categories.to_a
    #     categories.must_include @tag
    #     categories.count(@dependent).must_equal 1
    #   end
    # end

    # scenario 'Adding notes' ~> needs javascript for the "add note" button

    scenario 'Viewing notes in admin show and edit works' do
      note = FactoryGirl.create :note, topic: 'internal_info', notable: offers(:basic)
      note_text = note.text

      visit rails_admin_path

      click_link 'Angebote', match: :first

      click_link 'Anzeigen'
      page.must_have_content note_text

      click_link 'Bearbeiten'
      page.must_have_content note_text

      page.must_have_css '.Note'
      page.must_have_css '.topic.internal_info'
    end
  end
end
