# encoding: UTF-8
# frozen_string_literal: true

require_relative '../test_helper'
include Warden::Test::Helpers

feature 'Admin Backend' do
  let(:researcher) { FactoryGirl.create :researcher }
  let(:superuser) { FactoryGirl.create :super }

  describe 'as researcher' do
    before { login_as researcher }

    # scenario 'Administrating Offers' do
    #   visit rails_admin_path
    #
    #   click_link 'Angebote', match: :first
    #   click_link 'Neu hinzuf?gen'
    #
    #   assert_difference 'Offer.count', 1 do
    #     select 'Family', from: 'offer_section_id'
    #     fill_in 'offer_name', with: 'testangebot'
    #     fill_in 'offer_description', with: 'testdescription'
    #     select 'basicNextStep', from: 'offer_next_step_ids'
    #     select 'Personal', from: 'offer_encounter'
    #     select 'basicLocation', from: 'offer_location_id'
    #     # select 'foobar', from: 'offer_organization_ids'
    #     select 'English', from: 'offer_language_filter_ids'
    #     select 'basicSplitBaseTitle', from: 'offer_split_base_id'
    #     select 'basicSolutionCategoryName', from: 'offer_solution_category_id'
    #     # NOTE: creation works without TargetAudienceFilter (Validation on update)
    #
    #     click_button 'Speichern'
    #     page.must_have_content 'Angebot wurde erfolgreich hinzugef?gt'
    #     page.must_have_content 'testangebot'
    #   end
    # end

    # rubocop:disable Style/AsciiComments
    # NOTE now in new Backend
    # scenario 'Administrating Organizations' do
    #   visit rails_admin_path
    #
    #   click_link 'Organisationen', match: :first
    #   click_link 'Neu hinzufügen'
    #
    #   assert_difference 'Organization.count', 1 do
    #     fill_in 'organization_name', with: 'testorganisation'
    #     fill_in 'organization_description', with: 'testdescription'
    #     select 'e.V.', from: 'organization_legal_form'
    #     select 'basicLocation', from: 'organization_location_ids'
    #     select 'Diakonie', from: 'organization_umbrella_filter_ids'
    #     select 'http://basic.com', from: 'organization_website_id'
    #     check 'organization_accredited_institution'
    #
    #     click_button 'Speichern'
    #     page.must_have_content 'testorganisation'
    #     page.must_have_content 'Organisation wurde erfolgreich hinzugefügt'
    #     page.must_have_content researcher.email
    #   end
    # end

    # scenario 'Try to create organization with/out hq-location' do
    #   orga = organizations(:basic)
    #   location = FactoryGirl.create :location, :hq, organization: orga
    #   orga.update_columns aasm_state: 'initialized', created_by: researcher.id
    #
    #   visit rails_admin_path
    #   click_link 'Organisationen', match: :first
    #   click_link 'Bearbeiten', match: :first
    #
    #   click_link 'Als komplett markieren', match: :first
    #   page.must_have_content 'Zustandsänderung konnte nicht erfolgen'
    #   page.must_have_content 'nicht valide'
    #
    #   # 1: With two hq locations
    #   # click_button 'Speichern'
    #   click_link 'Als komplett markieren', match: :first
    #   page.must_have_content 'nicht valide'
    #   page.must_have_content 'Es muss genau eine HQ-Location zugeordnet werden'
    #
    #   # 2: With non-hq locations
    #   locations(:basic).update_column :hq, false
    #   location.update_column :hq, false
    #   # click_button 'Speichern'
    #   click_link 'Als komplett markieren', match: :first
    #   page.must_have_content 'nicht valide'
    #   page.must_have_content 'Es muss genau eine HQ-Location zugeordnet werden'
    #
    #   # 3: With one hq location
    #   location.update_column :hq, true
    #   # click_button 'Speichern'
    #   click_link 'Als komplett markieren', match: :first
    #   # page.must_have_content 'Organisation wurde erfolgreich aktualisiert'
    #
    #   # complete works
    #   # click_link 'Als komplett markieren', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich.'
    #
    #   click_link 'Approval starten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #
    #   # There is no approve link as same user
    #   # page.wont_have_link 'Freischalten'
    #   # TODO: change this!
    #   page.must_have_link 'Freischalten'
    #
    #   # Approval works as different user
    #   login_as superuser
    #   visit current_path
    #   page.must_have_link 'Freischalten'
    #   click_link 'Freischalten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    # end

    # scenario 'Deactivate Organization' do
    #   orga = organizations(:basic)
    #   split_base = split_bases(:basic)
    #   FactoryGirl.create :offer, split_base: split_base, aasm_state: :completed
    #   FactoryGirl.create :offer, split_base: split_base,
    #                              aasm_state: :internal_feedback
    #
    #   visit rails_admin_path
    #   click_link 'Organisationen', match: :first
    #   click_link 'Bearbeiten', match: :first
    #
    #   # Deactivation button click: deactivates orga and all its approved offers
    #
    #   orga.visible_in_frontend?.must_equal true
    #   orga.offers.select(:aasm_state).map(&:aasm_state).must_equal(
    #     %w(approved completed internal_feedback)
    #   )
    #
    #   click_link 'Deaktivieren (External Feedback)', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #
    #   orga.reload.must_be :external_feedback?
    #   orga.offers.select(:aasm_state).map(&:aasm_state).must_equal(
    #     %w(organization_deactivated completed internal_feedback)
    #   )
    #
    #   # Approve button click: reactivates orga and all its approved offers
    #
    #   click_link 'Freischalten (Comms-Only)', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #
    #   orga.reload.must_be :approved?
    #   orga.offers.select(:aasm_state).map(&:aasm_state).must_equal(
    #     %w(approved completed internal_feedback)
    #   )
    # end

    # scenario 'Set offer completed, then edit and back to completed' do
    #   split_base = split_bases(:basic)
    #   offer = FactoryGirl.create :offer, split_base: split_base
    #
    #   visit rails_admin_path
    #   click_link 'Angebote', match: :first
    #   click_link 'Bearbeiten', match: :first
    #
    #   offer.must_be :initialized?
    #
    #   click_link 'Als komplett markieren', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :completed?
    #
    #   click_link 'Erneut bearbeiten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :edit?
    #
    #   click_link 'Als komplett markieren', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :completed?
    # end
    #
    # scenario 'disapprove offer then edit and approve it again' do
    #   split_base = split_bases(:basic)
    #   offer = FactoryGirl.create :offer, split_base: split_base
    #
    #   visit rails_admin_path
    #   click_link 'Angebote', match: :first
    #   click_link 'Bearbeiten', match: :first
    #
    #   offer.must_be :initialized?
    #
    #   click_link 'Als komplett markieren', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :completed?
    #
    #   click_link 'Approval starten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :approval_process?
    #
    #   click_link 'Disapprove', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :disapproved?
    #
    #   click_link 'Erneut bearbeiten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :edit?
    #
    #   click_link 'Als komplett markieren', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :completed?
    #
    #   click_link 'Approval starten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :approval_process?
    #
    #   click_link 'Freischalten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :approved?
    # end
    #
    # scenario 'under_construction state should work correctly on offer' do
    #   split_base = split_bases(:basic)
    #   offer = FactoryGirl.create :offer, :approved, split_base: split_base
    #
    #   visit rails_admin_path
    #   click_link 'Angebote', match: :first
    #   click_link 'Bearbeiten', match: :first
    #
    #   offer.must_be :approved?
    #
    #   click_link 'Webseite im Aufbau', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :under_construction?
    #
    #   click_link 'Checkup starten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :checkup_process?
    #
    #   click_link 'Freischalten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :approved?
    # end
    #
    # scenario 'create a seasonal pending offer' do
    #   split_base = split_bases(:basic)
    #   offer = FactoryGirl.create :offer, split_base: split_base,
    #                                      starts_at: (Time.zone.now + 1.day)
    #
    #   visit rails_admin_path
    #   click_link 'Angebote', match: :first
    #   click_link 'Bearbeiten', match: :first
    #
    #   offer.must_be :initialized?
    #
    #   click_link 'Als komplett markieren', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :completed?
    #
    #   click_link 'Approval starten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :approval_process?
    #
    #   click_link 'Freischalten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :seasonal_pending?
    #
    #   # simulate worker
    #   offer.update_columns starts_at: (Time.zone.now - 1.day), aasm_state: 'approved'
    #   offer.reload.must_be :approved?
    #   offer.reload.valid?.must_equal true
    # end
    #
    # scenario 'checkup_process must be possible for invalid offers' do
    #   researcher.user_teams = [UserTeam.first]
    #   split_base = split_bases(:basic)
    #   offer = FactoryGirl.create :offer, :approved, split_base: split_base
    #
    #   offer.valid?.must_equal true
    #   visit rails_admin_path
    #   click_link 'Angebote', match: :first
    #   click_link 'Bearbeiten', match: :first
    #
    #   # simulate invalid age in other deactivation state (offer invalid)
    #   offer.update_columns(
    #     aasm_state: 'internal_feedback',
    #     starts_at: Time.zone.now,
    #     expires_at: Time.zone.now - 1.day
    #   )
    #   offer.valid?.must_equal false
    #
    #   page.must_have_link 'Deaktivieren (External Feedback)'
    #   page.must_have_link 'Checkup starten'
    #
    #   # transition to other state than 'checkup_process' is not allowed
    #   click_link 'Deaktivieren (External Feedback)', match: :first
    #   page.must_have_content 'Zustandsänderung konnte nicht erfolgen'
    #   page.must_have_content 'nicht valide'
    #   offer.reload.must_be :internal_feedback?
    #
    #   # transition to other 'checkup_process' works
    #   click_link 'Checkup starten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :checkup_process?
    # end
    #
    # scenario 'edit-state must be possible for invalid offers' do
    #   split_base = split_bases(:basic)
    #   offer = FactoryGirl.create :offer, :approved, split_base: split_base
    #
    #   offer.valid?.must_equal true
    #   visit rails_admin_path
    #   click_link 'Angebote', match: :first
    #
    #   # simulate expired offer in other deactivation state (offer invalid)
    #   offer.update_columns(
    #     aasm_state: 'completed',
    #     starts_at: Time.zone.now,
    #     expires_at: Time.zone.now - 1.day
    #   )
    #   offer.valid?.must_equal false
    #
    #   # transition to other state than 'checkup_process' is not allowed
    #   click_link 'Bearbeiten', match: :first
    #   page.wont_have_link 'Approval starten'
    #   # click_link 'Approval starten', match: :first
    #   # page.must_have_content 'Zustandsänderung konnte nicht erfolgen'
    #   # page.must_have_content 'nicht valide'
    #   # offer.reload.must_be :completed?
    #
    #   # transition to other 'edit' works
    #   page.must_have_link 'Erneut bearbeiten'
    #   click_link 'Erneut bearbeiten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :edit?
    # end
    #
    # scenario 'deactivate seasonal_pending offer and reactivate it afterwards' do
    #   split_base = split_bases(:basic)
    #   offer = FactoryGirl.create :offer, :approved,
    #                              split_base: split_base,
    #                              starts_at: (Time.zone.now - 1.day)
    #
    #   offer.aasm_state = 'paused'
    #   offer.must_be :paused?
    #
    #   visit rails_admin_path
    #   click_link 'Angebote', match: :first
    #   click_link 'Bearbeiten', match: :first
    #
    #   click_link 'Checkup starten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :checkup_process?
    #
    #   click_link 'Freischalten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :approved?
    # end

    # NOTE now in new Backend
    # scenario 'Deactivate Organization and then set to under_construction' do
    #   orga = organizations(:basic)
    #   split_base = split_bases(:basic)
    #   FactoryGirl.create :offer, split_base: split_base,
    #                              aasm_state: :completed
    #   FactoryGirl.create :offer, split_base: split_base,
    #                              aasm_state: :internal_feedback
    #
    #   visit rails_admin_path
    #   click_link 'Organisationen', match: :first
    #   click_link 'Bearbeiten', match: :first
    #
    #   # Deactivation button click: deactivates orga and all its approved offers
    #   orga.visible_in_frontend?.must_equal true
    #   orga.offers.select(:aasm_state).map(&:aasm_state).must_equal(
    #     %w(approved completed internal_feedback)
    #   )
    #
    #   click_link 'Deaktivieren (External Feedback)', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #
    #   orga.reload.must_be :external_feedback?
    #   orga.offers.select(:aasm_state).map(&:aasm_state).must_equal(
    #     %w(organization_deactivated completed internal_feedback)
    #   )
    #
    #   click_link 'Webseite im Aufbau', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #
    #   orga.reload.must_be :under_construction?
    #   orga.offers.select(:aasm_state).map(&:aasm_state).must_equal(
    #     %w(organization_deactivated completed internal_feedback)
    #   )
    #
    #   # make last offer invalid => should not be approved or in checkup but
    #   # remain in its last deactivation-state
    #   orga.offers.last.update_columns expires_at: Time.zone.now - 1.day
    #
    #   # Approve button click: reactivates orga and all its approved offers
    #   click_link 'Freischalten (Comms-Only)', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #
    #   orga.reload.must_be :approved?
    #   orga.offers.select(:aasm_state).map(&:aasm_state).must_equal(
    #     %w(approved completed internal_feedback)
    #   )
    # end

    # scenario 'Try to create offer with errors' do
    #   location = FactoryGirl.create(:location, name: 'testname')
    #   contact_person = FactoryGirl.create :contact_person
    #
    #   visit rails_admin_path
    #
    #   click_link 'Angebote', match: :first
    #   click_link 'Neu hinzufügen'
    #
    #   fill_in 'offer_name', with: 'testangebot'
    #   fill_in 'offer_description', with: 'testdescription'
    #   select 'basicNextStep', from: 'offer_next_step_ids'
    #   select 'Personal', from: 'offer_encounter'
    #   select location.name, from: 'offer_location_id'
    #   # select 'foobar', from: 'offer_organization_ids'
    #   select 'basicSplitBaseTitle', from: 'offer_split_base_id'
    #
    #   click_button 'Speichern und bearbeiten'
    #
    #   # Orga/Location mismatch wasn't tested yet
    #   page.wont_have_content(
    #     'Location muss zu der unten angegebenen Organisation gehören.'
    #   )
    #   page.wont_have_content(
    #     'Organizations muss die des angegebenen Standorts beinhalten.'
    #   )
    #
    #   select contact_person.label, from: 'offer_contact_person_ids'
    #   click_button 'Speichern und bearbeiten'
    #   page.wont_have_content 'Age from darf nicht größer sein als Age to'
    #   page.must_have_content 'Contact people müssen alle zu einer der'\
    #                          ' ausgewählten Organisationen gehören oder als'\
    #                          ' SPoC markiert sein'
    #
    #   # contact_person becomes SPoC, still needs target_audience
    #   contact_person.update_column :spoc, true
    #   select 'Family', from: 'offer_section_id'
    #   click_button 'Speichern und bearbeiten'
    #   page.wont_have_content 'Contact people müssen alle zu einer der'\
    #                          ' ausgewählten Organisationen gehören oder als'\
    #                          ' SPoC markiert sein'
    #
    #   click_button 'Speichern und bearbeiten'
    #   page.must_have_content 'Language filters benötigt mindestens einen'\
    #                          ' Sprachfilter'
    #
    #   select 'basicSolutionCategoryName', from: 'offer_solution_category_id'
    #   click_button 'Speichern und bearbeiten'
    #   page.wont_have_content 'Solution Category benötigt mindestens einen'\
    #                          ' Lösungskategorie'
    #
    #   # language filter selected, it saves
    #   select 'English', from: 'offer_language_filter_ids'
    #   click_button 'Speichern und bearbeiten'
    #   page.wont_have_content 'Language filters benötigt mindestens einen'\
    #                          ' Sprachfilter'
    #   page.must_have_content 'Angebot wurde erfolgreich hinzugefügt'
    #
    #   ## Test Update validations
    #   # binding.pry
    #   # try to save => does not work (needs target audience filter)
    #   click_button 'Speichern und bearbeiten'
    #   page.must_have_content 'Angebot wurde nicht aktualisiert'
    #   page.must_have_content 'benötigt mindestens einen Target Audience Filter'
    #   # directly create FiltersOffer (TargetAudienceFilter)
    #   TargetAudienceFiltersOffer.create!(
    #     offer_id: Offer.where(name: 'testangebot').first.id,
    #     target_audience_filter_id: TargetAudienceFilter.find_by(name: 'Bekannte').id
    #   )
    #   # Force Form Reload (..)
    #   click_link 'Anzeigen'
    #   click_link 'Bearbeiten'
    #   click_button 'Speichern und bearbeiten'
    #   page.wont_have_content 'benötigt mindestens einen Target Audience Filter'
    #
    #   # Try to complete, doesnt work
    #   click_link 'Als komplett markieren', match: :first
    #   page.must_have_content 'Zustandsänderung konnte nicht erfolgen'
    #   page.must_have_content 'nicht valide'
    #
    #   # See what the issue is (orga/location mismatch)
    #   click_button 'Speichern und bearbeiten'
    #   page.must_have_content 'Angebot wurde nicht aktualisiert'
    #   page.must_have_content(
    #     'Location muss zu der unten angegebenen Organisation gehören.'
    #   )
    #   page.must_have_content(
    #     'Organizations muss die des angegebenen Standorts beinhalten.'
    #   )
    #
    #   # Fix Orga/Location mismatch, still needs categories
    #   location.update_column :organization_id, 1
    #   click_button 'Speichern und bearbeiten'
    #   page.wont_have_content(
    #     'Location muss zu der unten angegebenen Organisation gehören.'
    #   )
    #   page.wont_have_content(
    #     'Organizations muss die des angegebenen Standorts beinhalten.'
    #   )
    #
    #   # Fill categories, it saves again
    #   select 'main1', from: 'offer_category_ids'
    #   click_button 'Speichern und bearbeiten'
    #   page.must_have_content 'Angebot wurde erfolgreich aktualisiert'
    #
    #   # Complete works
    #   click_link 'Als komplett markieren', match: :first
    #   page.wont_have_content 'Zustandsänderung konnte nicht erfolgen'
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    # end
    #
    # scenario 'Approve offer' do
    #   orga = organizations(:basic)
    #   orga.update_column :aasm_state, 'completed'
    #
    #   researcher.user_teams = [UserTeam.first]
    #
    #   # Create incomplete offer
    #   visit rails_admin_path
    #
    #   click_link 'Angebote', match: :first
    #   click_link 'Neu hinzufügen'
    #
    #   select 'Family', from: 'offer_section_id'
    #   fill_in 'offer_name', with: 'testangebot'
    #   fill_in 'offer_description', with: 'testdescription'
    #   select 'basicNextStep', from: 'offer_next_step_ids'
    #   select 'Hotline', from: 'offer_encounter'
    #   select 'basicLocation', from: 'offer_location_id'
    #   select 'main1', from: 'offer_category_ids'
    #   select 'basicSolutionCategoryName', from: 'offer_solution_category_id'
    #
    #   ## Test general validations
    #
    #   # SplitBase given, needs an area and no location when remote
    #   select 'basicSplitBaseTitle', from: 'offer_split_base_id'
    #   click_button 'Speichern und bearbeiten'
    #   page.must_have_content 'Area muss ausgefüllt werden, wenn Encounter'\
    #                          ' nicht "personal" ist'
    #   page.must_have_content 'Location darf keinen Standort haben, wenn'\
    #                          ' Encounter nicht "personal" ist'
    #
    #   # area given and no location, needs language filter
    #   select 'Deutschland', from: 'offer_area_id'
    #   select '', from: 'offer_location_id'
    #   click_button 'Speichern'
    #   page.wont_have_content 'Area muss ausgefüllt werden, wenn Encounter'\
    #                          ' nicht "personal" ist'
    #   page.wont_have_content 'Location darf keinen Standort haben, wenn'\
    #                          ' Encounter nicht "personal" ist'
    #   page.must_have_content 'Language filters benötigt mindestens einen'\
    #                          ' Sprachfilter'
    #
    #   # language filter given, needs target audience
    #   select 'Deutsch', from: 'offer_language_filter_ids'
    #   click_button 'Speichern und bearbeiten'
    #   page.wont_have_content 'Language filters benötigt mindestens einen'\
    #                          ' Sprachfilter'
    #   page.must_have_content 'Angebot wurde erfolgreich hinzugefügt'
    #   offer = Offer.last
    #
    #   # target audience is given, it saves
    #   # directly create FiltersOffer (TargetAudienceFilter)
    #   TargetAudienceFiltersOffer.create!(
    #     offer_id: offer.id,
    #     target_audience_filter_id: TargetAudienceFilter.first.id
    #   )
    #   # Force Form Reload (..)
    #   click_link 'Anzeigen'
    #   click_link 'Bearbeiten'
    #   click_link 'Als komplett markieren', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :completed?
    #
    #   # Orga not yet done -> can't start approval
    #   page.wont_have_link 'Approval starten'
    #
    #   # Finish orga -> start approval
    #   orga.update_column :aasm_state, 'approved'
    #   click_link 'Anzeigen' # force reload
    #   click_link 'Bearbeiten'
    #   click_link 'Approval starten', match: :first
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :approval_process?
    #
    #   # There is no approve link as same user
    #   # page.wont_have_link 'Freischalten'
    #   # TODO: reenable guard
    #
    #   # Approval as different user
    #   login_as superuser
    #   visit current_path
    #   page.must_have_link 'Freischalten'
    #
    #   ## Test (after-)approval update validations
    #
    #   # Try to approve, doesnt work
    #   # offer.reload.valid?.must_equal true
    #   # click_link 'Freischalten', match: :first
    #   # page.must_have_content 'Zustandsänderung konnte nicht erfolgen'
    #   # page.must_have_content 'nicht valide'
    #   # offer.reload.must_be :approval_process?
    #
    #   # Organization needs to be approved (only validated on approve)
    #   # page.must_have_content 'Organizations darf nur bestätigte Organisationen'\
    #   #                        ' beinhalten.'
    #
    #   # Organization gets approved (via all done), saves
    #   # orga.update_column :aasm_state, 'all_done'
    #   # click_button 'Speichern und bearbeiten'
    #   # page.must_have_content 'Angebot wurde erfolgreich aktualisiert'
    #
    #   # Approval works
    #   click_link 'Freischalten', match: :first
    #   page.wont_have_content 'Organizations darf nur bestätigte Organisationen'\
    #                          ' beinhalten.'
    #   page.must_have_content 'Zustandsänderung war erfolgreich'
    #   offer.reload.must_be :approved?
    # end
    #
    # scenario 'Duplicate offer works with an associated opening' do
    #   Opening::Create.(day: 'mon', open: '00:00', close: '09:00')
    #   visit rails_admin_path
    #
    #   click_link 'Angebote', match: :first
    #   click_link 'Duplizieren'
    #
    #   select 'Mon 00:00-09:00', from: 'offer_opening_ids'
    #
    #   click_button 'Speichern'
    #
    #   page.must_have_content 'Angebot wurde erfolgreich hinzugefügt'
    # end

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

    # scenario 'Duplicate organization' do
    #   visit rails_admin_path
    #
    #   click_link 'Organisationen', match: :first
    #   click_link 'Duplizieren'
    #   fill_in 'organization_name', with: 'kopietestname'
    #
    #   click_button 'Speichern'
    #
    #   page.must_have_content 'kopietestname'
    # end
    # rubocop:enable Style/AsciiComments

    scenario 'Duplicate contact_person' do
      FactoryGirl.create :contact_person, spoc: true, offers: [offers(:basic)]

      visit rails_admin_path
      click_link 'Kontaktpersonen', match: :first
      click_link 'Duplizieren', match: :first
      click_button 'Speichern'
      page.wont_have_content 'Kontaktperson wurde nicht hinzugefügt'
      page.must_have_content 'Kontaktperson wurde erfolgreich hinzugefügt'
    end

    scenario 'New category missing section filter' do
      visit rails_admin_path
      click_link 'Problem-Kategorien', match: :first
      click_link 'Neu hinzufügen', match: :first
      fill_in 'category_name_de', with: 'testkategorie'
      click_button 'Speichern'
      page.must_have_content 'benötigt mindestens eine clarat-Welt'
    end

    scenario 'Try to edit existing category and remove sections' do
      visit rails_admin_path
      click_link 'Problem-Kategorien', match: :first
      click_link 'Bearbeiten', match: :first
      unselect 'Family', from: 'category_section_ids'
      unselect 'Refugees', from: 'category_section_ids'
      click_button 'Speichern und bearbeiten'
      page.must_have_content 'Kategorie wurde nicht aktualisiert'
      page.must_have_content 'benötigt mindestens eine clarat-Welt'

      select 'Family', from: 'category_section_ids'
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

    # scenario 'Viewing notes in admin show and edit works' do
    #   note = FactoryGirl.create :note, topic: 'internal_info', notable: offers(:basic)
    #   note_text = note.text
    #
    #   visit rails_admin_path
    #
    #   click_link 'Angebote', match: :first
    #
    #   click_link 'Anzeigen'
    #   page.must_have_content note_text
    #
    #   click_link 'Bearbeiten'
    #   page.must_have_content note_text
    #
    #   page.must_have_css '.Note'
    #   page.must_have_css '.topic.internal_info'
    # end
  end
end
