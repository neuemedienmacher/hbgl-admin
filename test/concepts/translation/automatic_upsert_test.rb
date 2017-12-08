# frozen_string_literal: true

require_relative '../../test_helper'
# rubocop:disable Metrics/ClassLength
class AutomaticUpsertTest < ActiveSupport::TestCase
  let(:operation) { Translation::AutomaticUpsert }

  let(:family_section_orga) do
    FactoryBot.create(:organization, :approved, section: :family)
  end

  let(:refugees_section_orga) do
    FactoryBot.create(:organization, :approved, section: :refugees)
  end

  let(:family_offer) do
    offer = FactoryBot.create :offer, :approved,
                              organizations: [family_section_orga]
    # offer.section = FactoryBot.create(:section, :family)
    offer.tags = [FactoryBot.create(:tag)]
    offer.save
    offer
  end

  let(:refugees_offer) do
    offer = FactoryBot.create :offer, :approved,
                              organizations: [refugees_section_orga]
    # offer.section = FactoryBot.create(:section, :refugees)
    offer.tags = [FactoryBot.create(:tag)]
    offer.save
    offer
  end

  it 'should only create initial system-assignment for German translation'\
     ' that belongs to a refugees offer' do
    assignments =
      refugees_offer.translations.where(locale: 'de').first.assignments
    assignments.count.must_equal 1
    assignments.first.creator_id.must_equal User.system_user.id
    assignments.first.receiver_id.must_equal User.system_user.id
    assignments.first.aasm_state.must_equal 'open'
  end

  it 'should create only one translation-team-assignment for a '\
     'new english translation' do
    orga = refugees_offer.organizations.first
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => orga)
    orga.translations.where(locale: 'en').count.must_equal 1
    assignments = orga.translations.where(locale: 'en').first.assignments
    assignments.count.must_equal 1
    assignments.last.creator_id.must_equal orga.created_by
    assert_nil assignments.last.receiver_id
    # test default for translator teams
    assignments.last.receiver_team_id.must_equal 1
    assignments.last.aasm_state.must_equal 'open'
  end

  it 'should correctly create a second assignment with a refugees offer' do
    orga = family_offer.organizations.first
    operation.({}, 'locale' => :ar, 'fields' => :all,
                   'object_to_translate' => orga)
    assignments = orga.translations.where(locale: 'ar').first.assignments
    assignments.count.must_equal 1
    assignments.first.creator_id.must_equal User.system_user.id
    assignments.first.receiver_id.must_equal User.system_user.id
    assignments.first.aasm_state.must_equal 'open'

    # simply running again does not create a new assignment
    operation.({}, 'locale' => :ar, 'fields' => :all,
                   'object_to_translate' => orga)
    assignments.count.must_equal 1

    # add a refugees offer to the organization and start Operation again
    refugees_offer.divisions.first
                  .update_columns organization_id: orga.id
    orga.in_section?('refugees').must_equal true
    operation.({}, 'locale' => :ar, 'fields' => :all,
                   'object_to_translate' => orga)
    assignments.count.must_equal 2
    assignments.last.creator_id.must_equal orga.created_by
    # test default for translator teams
    assignments.last.receiver_team_id.must_equal 1
    assignments.last.aasm_state.must_equal 'open'
  end

  it 'should assign to approver if creator is inactive' do
    orga = family_offer.organizations.first
    refugees_offer.divisions.first
                  .update_columns organization_id: orga.id
    User.find(orga.created_by).update_attributes(active: false)
    operation.({}, 'locale' => :ar, 'fields' => :all,
                   'object_to_translate' => orga)
    assignments = orga.translations.where(locale: 'ar').first.assignments
    assignments.last.creator_id.must_equal orga.approved_by
    assignments.last.aasm_state.must_equal 'open'
  end

  it 'should correctly create the second assignment as an offer side-effect' do
    orga = family_section_orga
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => orga)
    assignments = orga.translations.where(locale: 'en').first.assignments
    assignments.count.must_equal 1
    first_assignment = assignments.first
    first_assignment.creator_id.must_equal User.system_user.id
    first_assignment.receiver_id.must_equal User.system_user.id
    first_assignment.aasm_state.must_equal 'open'

    # add a refugees offer to the organization and start Operation again
    refugees_offer.divisions.first
                  .update_columns organization_id: orga.id
    refugees_offer.update_columns aasm_state: 'initialized'
    orga.sections.pluck(:identifier).include?('refugees').must_equal true
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => refugees_offer)
    assignments.count.must_equal 1

    # set state to approved => orga translation is generated
    refugees_offer.update_columns aasm_state: 'approved'
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => refugees_offer)
    assignments.count.must_equal 2
    first_assignment.reload.aasm_state.must_equal 'closed'
    second_assignment = assignments.where.not(id: first_assignment.id).first
    second_assignment.creator_id.must_equal refugees_offer.created_by
    # test default for translator teams
    second_assignment.receiver_team_id.must_equal 1
    second_assignment.aasm_state.must_equal 'open'

    # running again does not generate a new orga-assignment (already existing)
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => refugees_offer)
    assignments.count.must_equal 2
  end

  it 'only creates system-assignment for family-en-OrganizationTranslation' do
    orga = family_offer.organizations.first
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => orga)
    assignments = orga.translations.where(locale: 'en').first.assignments
    assignments.count.must_equal 1
    assignments.first.creator_id.must_equal User.system_user.id
    assignments.first.receiver_id.must_equal User.system_user.id
    assignments.first.aasm_state.must_equal 'open'
  end

  it 'should create system-assignment for contact_person' do
    cont =
      FactoryBot.create :contact_person, responsibility: 'Geduld und Disziplin'
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => cont)
    assignments = cont.translations.where(locale: 'en').first.assignments
    assignments.count.must_equal 1
    assignments.first.creator_id.must_equal User.system_user.id
    assignments.first.receiver_id.must_equal User.system_user.id
    assignments.first.aasm_state.must_equal 'open'
  end

  it 'should create translator-team Assignment for English' do
    orga = refugees_offer.organizations.first
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => orga)
    user = User.find(orga.created_by)
    assignments = orga.translations.where(locale: 'en').first.assignments
    assignments.count.must_equal 1
    assignments.first.creator_id.must_equal orga.created_by
    # test default for translator teams
    assignments.first.receiver_team_id.must_equal 1
    assignments.first.message.must_equal "(#{user.name}) GoogleTranslate"
    assignments.first.aasm_state.must_equal 'open'
  end

  it 'should only create initial system-assignment for German translation'\
     ' that belongs to a family-only offer' do
    operation.({}, 'locale' => :de, 'fields' => :all,
                   'object_to_translate' => family_offer)
    assignments = family_offer.translations.where(
      locale: 'de'
    ).first.assignments
    assignments.count.must_equal 1
    assignments.first.creator_id.must_equal User.system_user.id
    assignments.first.receiver_id.must_equal User.system_user.id
    assert_nil assignments.first.receiver_team_id
    assignments.first.message.must_equal 'Managed by system'
    assignments.first.aasm_state.must_equal 'open'
  end

  it 'should only create the initial system-assignment for English '\
     'translation that belongs to a family-only offer' do
    operation.({}, 'locale' => :en, 'fields' => :all,
                   'object_to_translate' => family_offer)
    assignments = family_offer.translations.where(
      locale: 'en'
    ).first.assignments
    assignments.count.must_equal 1
    assignments.first.creator_id.must_equal User.system_user.id
    assignments.first.receiver_id.must_equal User.system_user.id
    assert_nil assignments.first.receiver_team_id
    assignments.first.message.must_equal 'Managed by system'
    assignments.first.aasm_state.must_equal 'open'
  end

  it 'should raise an error for unknown translation-strategies' do
    assert_raises(RuntimeError) do
      operation.({}, 'locale' => :en, 'fields' => [:encounter],
                     'object_to_translate' => family_offer)
    end
  end
end
# rubocop:enable Metrics/ClassLength
