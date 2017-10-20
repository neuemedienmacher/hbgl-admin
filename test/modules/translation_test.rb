# frozen_string_literal: true

require_relative '../test_helper'

class TestClass
  # rubocop:disable Style/PredicateName
  def self.has_many *; end
  # rubocop:enable Style/PredicateName

  include Translation

  attr_accessor :somefield
  translate :somefield
end

describe Translation do
  subject { TestClass.new }
  let(:translation) do
    OpenStruct.new(somefield: 'some translation', locale: 'en')
  end

  describe 'methods' do
    describe 'translated field getter' do
      it 'should find the content of a translation' do
        subject.expect_chain(:translations, :find_by).returns(translation)
        subject.translated_somefield.must_equal 'some translation'
      end
    end
  end

  describe 'field getter for specific translation' do
    it 'should find a specific translation' do
      subject.expect_chain(:translations, :where, :select).returns [translation]
      subject.somefield_en.must_equal 'some translation'
    end
  end

  describe 'automated translation check' do
    it 'should call the check on the current translation' do
      translation = OfferTranslation.new(source: 'GoogleTranslate')
      subject.expect_chain(:translations, :find_by).returns translation
      subject.translation_automated?.must_equal true
    end
  end

  describe 'cache key' do
    it 'should set the cache key to include the current locale' do
      # TestClass doesn't have super; we need an AR model including Translation
      Offer.new.cache_key.must_match(/.+de/)
    end
  end
end
