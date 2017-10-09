# frozen_string_literal: true

require_relative '../test_helper'

class RegenerateHtmlWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures

  let(:worker) { RegenerateHtmlWorker.new }

  describe 'perform' do
    it 'should infuse german offer and orga translation where key is found' do
      offer = FactoryGirl.create :offer, description: 'xy foo bar'
      orga = FactoryGirl.create :organization, :with_translation,
                                description: 'xy foo bar'
      Offer.stub_chain(:visible_in_frontend, :where).returns([offer])
      Organization.stub_chain(:visible_in_frontend, :where).returns([orga])

      FactoryGirl.create :definition, key: 'foo', explanation: 'xy'

      worker.perform

      offer.translations.first.reload.description.must_include(
        "<p>xy <dfn class='JS-tooltip' data-id='1'>foo</dfn> bar</p>"
      )
      orga.translations.first.reload.description.must_include(
        "<p>xy <dfn class='JS-tooltip' data-id='1'>foo</dfn> bar</p>"
      )
    end
  end
end
