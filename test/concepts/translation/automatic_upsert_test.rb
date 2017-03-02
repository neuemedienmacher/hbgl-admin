# frozen_string_literal: true
require_relative '../../test_helper'
# rubocop:disable Metrics/ClassLength
class AutomaticUpsertTest < ActiveSupport::TestCase
  let(:operation) { Translation::AutomaticUpsert }

  it 'should only create initial system-assignment for German translation that belongs to a refugees-offer' do
    offer = FactoryGirl.create :offer, :approved
    offer.section_filters << SectionFilter.find_by(identifier: 'refugees')
    assignments = offer.translations.where(locale: 'de').first.assignments
    assignments.count.must_equal 1
    assignments.first.creator_id.must_equal User.system_user.id
    assignments.first.receiver_id.must_equal User.system_user.id
    assignments.first.aasm_state.must_equal 'open'
  end

  it 'should create only one translation-team-assignment for a new english translation' do
    offer = FactoryGirl.create :offer, :approved
    offer.section_filters << SectionFilter.find_by(identifier: 'refugees')
    orga = offer.organizations.first
    orga.in_section?('refugees').must_equal true
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => orga)
    orga.translations.where(locale: 'en').count.must_equal 1
    assignments = orga.translations.where(locale: 'en').first.assignments
    assignments.count.must_equal 1
    assignments.last.creator_id.must_equal orga.approved_by
    assert_nil assignments.last.receiver_id
    assignments.last.receiver_team_id.must_equal 1 # test default for translator teams
    assignments.last.aasm_state.must_equal 'open'
  end

  it 'should correctly create a second assignment with a refugees-offer' do
    offer = FactoryGirl.create :offer, :approved
    offer.section_filters = [SectionFilter.find_by(identifier: 'family')]
    orga = offer.organizations.first
    operation.({}, 'locale' => :ar, 'fields' => :all,
                   'object_to_translate' => orga)
    assignments = orga.translations.where(locale: 'ar').first.assignments
    assignments.count.must_equal 1
    assignments.first.creator_id.must_equal User.system_user.id
    assignments.first.receiver_id.must_equal User.system_user.id
    assignments.first.aasm_state.must_equal 'open'

    # simply running again does not create a new assignment
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => orga)
    assignments.count.must_equal 1

    # add a refugees offer to the organization and start Operation again
    offer.section_filters << SectionFilter.find_by(identifier: 'refugees')
    orga.in_section?('refugees').must_equal true
    operation.({}, 'locale' => :ar, 'fields' => :all,
                   'object_to_translate' => orga)
    assignments.count.must_equal 2
    assignments.last.creator_id.must_equal orga.approved_by
    assignments.last.receiver_team_id.must_equal 1 # test default for translator teams
    assignments.last.aasm_state.must_equal 'open'
  end

  it 'should correctly create the second assignment as an offer side-effect' do
    offer = FactoryGirl.create :offer, :approved
    offer.section_filters = [SectionFilter.find_by(identifier: 'family')]
    orga = offer.organizations.first
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => orga)
    assignments = orga.translations.where(locale: 'en').first.assignments
    assignments.count.must_equal 1
    assignments.first.creator_id.must_equal User.system_user.id
    assignments.first.receiver_id.must_equal User.system_user.id
    assignments.first.aasm_state.must_equal 'open'

    # add a refugees offer to the organization and start Operation again
    offer.update_columns aasm_state: 'initialized'
    offer.section_filters << SectionFilter.find_by(identifier: 'refugees')
    orga.section_filters.pluck(:identifier).include?('refugees').must_equal true
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => offer)
    assignments.count.must_equal 1

    # set state to approved => orga translation is generated
    offer.update_columns aasm_state: 'approved'
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => offer)
    assignments.count.must_equal 2
    assignments.first.aasm_state.must_equal 'closed'
    assignments.last.creator_id.must_equal offer.approved_by
    assignments.last.receiver_team_id.must_equal 1 # test default for translator teams
    assignments.last.aasm_state.must_equal 'open'

    # running again does not generate a new orga-assignment (already existing)
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => offer)
    assignments.count.must_equal 2
  end

  it 'should only create system-assignment for family-en-OrganizationTranslation' do
    offer = FactoryGirl.create :offer, :approved
    offer.section_filters = [SectionFilter.find_by(identifier: 'family')]
    orga = offer.organizations.first
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => orga)
    assignments = orga.translations.where(locale: 'en').first.assignments
    assignments.count.must_equal 1
    assignments.first.creator_id.must_equal User.system_user.id
    assignments.first.receiver_id.must_equal User.system_user.id
    assignments.first.aasm_state.must_equal 'open'
  end

  it 'should create translator-team Assignment for English' do
    offer = FactoryGirl.create :offer, :approved
    offer.section_filters = [SectionFilter.find_by(identifier: 'refugees')]
    orga = offer.organizations.first
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => orga)
    user = User.find(orga.approved_by)
    assignments = orga.translations.where(locale: 'en').first.assignments
    assignments.count.must_equal 1
    assignments.first.creator_id.must_equal orga.approved_by
    assignments.first.receiver_team_id.must_equal 1 # test default for translator teams
    assignments.first.message.must_equal "(#{user.name}) GoogleTranslate"
    assignments.first.aasm_state.must_equal 'open'
  end

  it 'should only create initial system-assignment for German translation that belongs to a family-only offer' do
    offer = FactoryGirl.create :offer, :approved
    offer.section_filters = [SectionFilter.find_by(identifier: 'family')]
    operation.({}, 'locale' => :de, 'fields' => :all,
                   'object_to_translate' => offer)
    assignments = offer.translations.where(locale: 'de').first.assignments
    assignments.count.must_equal 1
    assignments.first.creator_id.must_equal User.system_user.id
    assignments.first.receiver_id.must_equal User.system_user.id
    assert_nil assignments.first.receiver_team_id
    assignments.first.message.must_equal 'Managed by system'
    assignments.first.aasm_state.must_equal 'open'
  end

  it 'should only create the initial system-assignment for English translation that belongs to a family-only offer' do
    offer = FactoryGirl.create :offer, :approved
    offer.section_filters = [SectionFilter.find_by(identifier: 'family')]
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => offer)
    assignments = offer.translations.where(locale: 'en').first.assignments
    assignments.count.must_equal 1
    assignments.first.creator_id.must_equal User.system_user.id
    assignments.first.receiver_id.must_equal User.system_user.id
    assert_nil assignments.first.receiver_team_id
    assignments.first.message.must_equal 'Managed by system'
    assignments.first.aasm_state.must_equal 'open'
  end

  it 'should raise an error for unknown translation-strategies' do
    offer = FactoryGirl.create :offer, :approved
    offer.section_filters = [SectionFilter.find_by(identifier: 'family')]
    assert_raises(RuntimeError) do
      operation.({}, 'locale' => :en, 'fields' => [:unknown],
                     'object_to_translate' => offer)
    end
  end
end
# rubocop:enable Metrics/ClassLength
