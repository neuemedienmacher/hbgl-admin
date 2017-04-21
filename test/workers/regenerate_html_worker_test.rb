# frozen_string_literal: true
require_relative '../test_helper'

class RegenerateHtmlWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures
  let(:worker) { RegenerateHtmlWorker.new }

  describe 'perform' do
    before do
      # Run worker initially so everything in database is updated to the
      # most recent state
      worker.perform
    end

    it 'should regenerate german offer and orga translation' do
      offer = offers(:basic)
      orga = organizations(:basic)

      FactoryGirl.create :definition, key: offer.untranslated_description
      FactoryGirl.create :definition, key: orga.untranslated_description

      # Doesn't request translations
      GoogleTranslateCommunicator.expects(:get_translations).never
      worker.perform

      offer.reload.description.must_include(
        "<dfn class='JS-tooltip' data-id='1'>basicOfferDescription</dfn>"
      )
      orga.reload.description.must_include(
        "<dfn class='JS-tooltip' data-id='2'>basicOrganizationDescription</dfn>"
      )
    end
  end
end
