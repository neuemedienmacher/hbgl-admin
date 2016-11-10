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
      translation.old_next_steps.must_equal nil
      translation.opening_specification.must_equal nil
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
