# frozen_string_literal: true
require_relative '../../test_helper'
class LinkAndInfuseTest < ActiveSupport::TestCase
  let(:orga) { organizations(:basic) }
  let(:offer) { offers(:basic) }

  describe 'linking and ifusing' do
    it 'should put definition markup around the first found definition key and'\
       'link to offer' do
      offer.description = 'Little Mary had a little lamb.'
      offer.save!
      offer.definitions.count.must_equal 0

      deff = FactoryGirl.create :definition, key: 'little', explanation: 'small'

      Definition::LinkAndInfuse.(
        {},
        'object_to_link' => offer,
        'string_to_infuse' => offer.description,
        'definition_positions' => []
      )['infused_description'].must_equal(
        "<dfn class='JS-tooltip' data-id='1'>Little</dfn> Mary had a little"\
        ' lamb.'
      )
      offer.definitions.must_include deff
    end

    it 'infusing should be case insensitive' do
      orga.description = 'My sexual identity is great.'
      orga.save!
      FactoryGirl.create :definition, key: 'Sexual Identity'

      Definition::LinkAndInfuse.(
        {},
        'object_to_link' => orga,
        'string_to_infuse' => orga.description,
        'definition_positions' => []
      )['infused_description'].must_equal(
        "My <dfn class='JS-tooltip' data-id='1'>sexual identity</dfn>"\
        ' is great.'
      )
    end

    it 'infusing should only ever use the first definition key occurence when'\
       ' mutliple comma seperated keys are given' do
      orga.description = 'The big brown fox jumps over the apathetic, lazy dog.'
      orga.save!
      FactoryGirl.create :definition, key: 'big', explanation: 'huge'
      FactoryGirl.create :definition, key: 'lethargic, lazy, apathetic'

      Definition::LinkAndInfuse.(
        {},
        'object_to_link' => orga,
        'string_to_infuse' => orga.description,
        'definition_positions' => []
      )['infused_description'].must_equal(
        "The <dfn class='JS-tooltip' data-id='1'>big</dfn> brown fox jumps"\
        " over the <dfn class='JS-tooltip' data-id='2'>apathetic</dfn>, lazy"\
        ' dog.'
      )
    end

    it 'should link orga only to definition that is infused' do
      orga.description = 'The big brown fox jumps over the dog.'
      orga.save!
      orga.definitions.count.must_equal 0
      deff = FactoryGirl.create :definition, key: 'big', explanation: 'huge'
      FactoryGirl.create :definition, key: 'lethargic, lazy, apathetic'

      Definition::LinkAndInfuse.(
        {},
        'object_to_link' => orga,
        'string_to_infuse' => orga.description,
        'definition_positions' => []
      )['infused_description'].must_equal(
        "The <dfn class='JS-tooltip' data-id='1'>big</dfn> brown fox jumps"\
        ' over the dog.'\
      )
      orga.definitions.count.must_equal 1
      orga.definitions.must_include deff
    end

    it 'should find plural words although singular words are included and '\
       'first in key list' do
      orga.description = 'Die Weisungen'
      orga.save!
      FactoryGirl.create :definition, key: 'Weisung, Weisungen',
                                      explanation: 'Eine Weisung ist...'

      Definition::LinkAndInfuse.(
        {},
        'object_to_link' => orga,
        'string_to_infuse' => orga.description,
        'definition_positions' => []
      )['infused_description'].must_equal(
        "Die <dfn class='JS-tooltip' data-id='1'>Weisungen</dfn>"
      )
    end
  end
end
