# frozen_string_literal: true

require_relative '../test_helper'

class TranslationGenerationWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures
  let(:worker) { TranslationGenerationWorker.new }

  describe '#perform' do
    it 'should work for an offer in German' do
      offer = Offer.find(1)
      offer.update_columns(
        name: '*foo*', description: '*foo*', old_next_steps: '*foo*',
        opening_specification: '*foo*'
      )
      FactoryGirl.create :definition, key: 'foo'
      worker.perform :de, 'Offer', offer.id
      translation = offer.translations.where(locale: 'de').first
      translation.name.must_equal '*foo*'
      translation.description.must_equal(
        "<p><em><dfn class='JS-tooltip' data-id='1'>foo</dfn></em></p>\n"
      )
      translation.old_next_steps.must_equal "<p><em>foo</em></p>\n"
      translation.opening_specification.must_equal "<p><em>foo</em></p>\n"
    end

    it 'should work for an offer in English' do
      worker.perform :en, 'Offer', 1
      translation = OfferTranslation.last
      translation.name.must_equal 'GET READY FOR CANADA'
      translation.description.must_equal 'GET READY FOR CANADA'
      translation.old_next_steps.must_equal 'GET READY FOR CANADA'
      assert_nil translation.opening_specification
    end

    it 'should only translate for given set of fields if provided' do
      translation = OfferTranslation.last
      translation.name.must_equal 'GET READY FOR NAME'
      translation.description.must_equal 'GET READY FOR DESCRIPTION'
      # changes name field but not description
      worker.perform :en, 'Offer', 1, [:name]
      translation.reload.name.must_equal 'GET READY FOR CANADA'
      translation.reload.description.must_equal 'GET READY FOR DESCRIPTION'
      translation.reload.old_next_steps.must_equal 'GET READY FOR NEXT STEPS'
      assert_nil translation.opening_specification
    end

    it 'should work for an organization in German' do
      worker.perform :de, 'Organization', 1
      translation = Organization.find(1).translations.where(locale: 'de').first
      translation.description.must_equal "<p>basicOrganizationDescription</p>\n"
    end

    it 'should work for an organization in English' do
      worker.perform :en, 'Organization', 1
      translation = OrganizationTranslation.last
      translation.description.must_equal 'GET READY FOR CANADA'
    end
  end
end
