# frozen_string_literal: true

require_relative '../test_helper'

class RegenerateHtmlWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures

  let(:worker) { RegenerateHtmlWorker.new }

  describe 'perform' do
    it 'should infuse german offer and orga translation where key is found' do
      offer = FactoryBot.create :offer, description: 'xy foo bar'
      orga = FactoryBot.create :organization, :with_translation,
                               description: 'xy foo bar'
      Offer.stub_chain(:visible_in_frontend, :where).returns([offer])
      Organization.stub_chain(:visible_in_frontend, :where).returns([orga])

      df = FactoryBot.create :definition, key: 'foo', explanation: 'x'

      worker.perform

      offer.translations.first.reload.description.must_include(
        "<p>xy <dfn class='JS-tooltip' data-id='#{df.id}'>foo</dfn> bar</p>"
      )
      orga.translations.first.reload.description.must_include(
        "<p>xy <dfn class='JS-tooltip' data-id='#{df.id}'>foo</dfn> bar</p>"
      )
    end
  end
end
