require_relative '../test_helper'

class TranslationGenerationWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures
  let(:worker) { TranslationGenerationWorker.new }

  describe '#perform' do
    it 'should work for an offer in German' do
      Offer.find(1).update_columns(
        name: '*foo*', description: '*foo*', old_next_steps: '*foo*',
        opening_specification: '*foo*'
      )
      FactoryGirl.create :definition, key: 'foo'
      worker.perform :de, 'Offer', 1
      translation = OfferTranslation.last
      translation.name.must_equal '*foo*'
      translation.description.must_equal(
        "<p><em><dfn class='JS-tooltip' data-id='1'>foo</dfn></em></p>\n")
      translation.old_next_steps.must_equal "<p><em>foo</em></p>\n"
      translation.opening_specification.must_equal "<p><em>foo</em></p>\n"
    end

    it 'should work for an offer in English' do
      worker.perform :en, 'Offer', 1
      translation = OfferTranslation.last
      translation.name.must_equal 'GET READY FOR CANADA'
      translation.description.must_equal 'GET READY FOR CANADA'
      translation.old_next_steps.must_equal 'GET READY FOR CANADA'
      translation.opening_specification.must_equal 'GET READY FOR CANADA'
    end

    it 'should only translate for given set of fields if provided' do
      worker.perform :en, 'Offer', 1, [:name]
      translation = OfferTranslation.last
      translation.name.must_equal 'GET READY FOR CANADA'
      translation.description.must_equal ''
      assert_nil translation.old_next_steps
      assert_nil translation.opening_specification
    end

    it 'should work for an organization in German' do
      worker.perform :de, 'Organization', 1
      translation = OrganizationTranslation.last
      translation.description.must_equal "<p>basicOrganizationDescription</p>\n"
    end

    it 'should work for an organization in English' do
      worker.perform :en, 'Organization', 1
      translation = OrganizationTranslation.last
      translation.description.must_equal 'GET READY FOR CANADA'
    end

    # automated Assignments

    it 'should only create initial system-assignment for German translation that belongs to a refugees-offer' do
      Assignment.count.must_equal 0
      Offer.first.section_filters << SectionFilter.find_by(identifier: 'refugees')
      worker.perform :de, 'Offer', 1
      assignments = OfferTranslation.last.assignments
      assignments.count.must_equal 1
      assignments.first.creator_id.must_equal User.system_user.id
      assignments.first.reciever_id.must_equal User.system_user.id
      assignments.first.aasm_state.must_equal 'open'
    end

    it 'should create two assignments for refugees-en-organization' do
      Assignment.count.must_equal 0
      orga = Organization.first
      orga.offers.first.section_filters << SectionFilter.find_by(identifier: 'refugees')
      orga.section_filters.pluck(:identifier).include?('refugees').must_equal true
      worker.perform :en, 'Organization', 1
      assignments = OrganizationTranslation.last.assignments
      assignments.count.must_equal 2
      assignments.first.creator_id.must_equal orga.approved_by
      assignments.first.reciever_id.must_equal User.system_user.id
      assignments.first.aasm_state.must_equal 'closed'
      assignments.last.creator_id.must_equal User.system_user.id
      assignments.last.reciever_team_id.must_equal 1 # test default for translator teams
      assignments.last.aasm_state.must_equal 'open'
    end

    it 'should correctly create a second assignment with a refugees-offer' do
      Assignment.count.must_equal 0
      orga = Organization.find(1)
      worker.perform :en, 'Organization', orga.id
      assignments = OrganizationTranslation.last.assignments
      assignments.count.must_equal 1
      assignments.first.creator_id.must_equal User.system_user.id
      assignments.first.reciever_id.must_equal User.system_user.id
      assignments.first.aasm_state.must_equal 'open'

      # add a refugees offer to the organization and start worker again
      orga.offers.first.section_filters << SectionFilter.find_by(identifier: 'refugees')
      orga.section_filters.pluck(:identifier).include?('refugees').must_equal true
      worker.perform :en, 'Organization', orga.id
      assignments = OrganizationTranslation.last.assignments
      assignments.count.must_equal 2
      assignments.last.creator_id.must_equal User.system_user.id
      assignments.last.reciever_team_id.must_equal 1 # test default for translator teams
      assignments.last.aasm_state.must_equal 'open'
    end

    it 'should correctly create the second assignment as an offer side-effect' do
      Assignment.count.must_equal 0
      orga = Organization.find(1)
      worker.perform :en, 'Organization', orga.id
      assignments = OrganizationTranslation.last.assignments
      assignments.count.must_equal 1
      assignments.first.creator_id.must_equal User.system_user.id
      assignments.first.reciever_id.must_equal User.system_user.id
      assignments.first.aasm_state.must_equal 'open'

      # add a refugees offer to the organization and start worker again
      offer = orga.offers.first
      # first try with non-approved offer => should not generate translation
      offer.update_columns aasm_state: 'initialized'
      offer.section_filters << SectionFilter.find_by(identifier: 'refugees')
      orga.section_filters.pluck(:identifier).include?('refugees').must_equal true
      worker.perform :en, 'Offer', offer.id
      assignments = OrganizationTranslation.last.assignments
      assignments.count.must_equal 1

      # set state to approved => orga translation is generated
      offer.update_columns aasm_state: 'approved'
      worker.perform :en, 'Offer', offer.id
      assignments = OrganizationTranslation.last.assignments
      assignments.count.must_equal 2
      assignments.first.aasm_state.must_equal 'closed'
      assignments.last.creator_id.must_equal User.system_user.id
      assignments.last.reciever_team_id.must_equal 1 # test default for translator teams
      assignments.last.aasm_state.must_equal 'open'

      # running again does not generate a new orga-assignment (already existing)
      worker.perform :en, 'Offer', offer.id
      assignments = OrganizationTranslation.last.assignments
      assignments.count.must_equal 2
    end

    it 'should only create system-assignment for family-en-OrganizationTranslation' do
      Assignment.count.must_equal 0
      worker.perform :en, 'Organization', 1
      assignments = OrganizationTranslation.last.assignments
      assignments.count.must_equal 1
      assignments.first.creator_id.must_equal User.system_user.id
      assignments.first.reciever_id.must_equal User.system_user.id
      assignments.first.aasm_state.must_equal 'open'
    end

    it 'should create an initial and an updated Assignment for English' do
      Assignment.count.must_equal 0
      Offer.first.section_filters = [SectionFilter.find_by(identifier: 'refugees')]
      worker.perform :en, 'Offer', 1
      assignments = OfferTranslation.last.assignments
      assignments.count.must_equal 2
      assignments.first.creator_id.must_equal Offer.find(1).approved_by
      assignments.first.reciever_id.must_equal User.system_user.id
      assignments.first.aasm_state.must_equal 'closed'
      assignments.last.creator_id.must_equal User.system_user.id
      assignments.last.reciever_team_id.must_equal 1 # test default for transltor teams
      assignments.last.aasm_state.must_equal 'open'
    end

    it 'should only create initial system-assignment for German translation that belongs to a family-only offer' do
      Assignment.count.must_equal 0
      worker.perform :de, 'Offer', 1
      assignments = OfferTranslation.last.assignments
      assignments.count.must_equal 1
      assignments.first.creator_id.must_equal User.system_user.id
      assignments.first.reciever_id.must_equal User.system_user.id
      assignments.first.aasm_state.must_equal 'open'
    end

    it 'should only create the initial system-assignment for English translation that belongs to a family-only offer' do
      Assignment.count.must_equal 0
      worker.perform :en, 'Offer', 1
      assignments = OfferTranslation.last.assignments
      assignments.count.must_equal 1
      assignments.first.creator_id.must_equal User.system_user.id
      assignments.first.reciever_id.must_equal User.system_user.id
    end
  end

  ### PRIVATE METHODS ###

  describe '#direct_translate_via_strategy' do
    it 'should take the name unchanged' do
      object = OpenStruct.new(untranslated_name: 'foo')
      MarkdownRenderer.expects(:render).never
      Definition.expects(:infuse).never
      worker.send(:direct_translate_via_strategy, object, :name)
            .must_equal 'foo'
    end

    it 'should check for definitions and markdown in German descriptions' do
      MarkdownRenderer.expects(:render)
      Definition.expects(:infuse)
      worker.send(:direct_translate_via_strategy, OpenStruct.new, :description)
    end

    it 'should check only for markdown in non-German descriptions' do
      MarkdownRenderer.expects(:render)
      Definition.expects(:infuse).never
      worker.send(
        :direct_translate_via_strategy, OpenStruct.new, :description, :en)
    end

    it 'should check for markdown but not definitions in old_next_steps' do
      MarkdownRenderer.expects(:render)
      Definition.expects(:infuse).never
      worker.send(:direct_translate_via_strategy, OpenStruct.new, :old_next_steps)
    end

    it 'should check for md but not definitions in opening_specification' do
      MarkdownRenderer.expects(:render)
      Definition.expects(:infuse).never
      worker.send(
        :direct_translate_via_strategy, OpenStruct.new, :opening_specification)
    end

    it 'should raise an error for unknown strategies' do
      assert_raises(RuntimeError) do
        worker.send(:direct_translate_via_strategy, OpenStruct.new, :foobar)
      end
    end
  end
end
