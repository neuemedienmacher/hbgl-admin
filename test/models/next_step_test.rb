# frozen_string_literal: true
require_relative '../test_helper'

describe NextStep do
  let(:next_step) { NextStep.new }
  subject { next_step }

  describe 'callbacks' do
    describe 'after_save' do
      it 'should request new translations when saved for the first time' do
        next_step = FactoryGirl.build(:next_step)
        GengoCommunicator.any_instance.expects(:create_translation_jobs)
                         .with(next_step, 'text')
        next_step.save!
      end

      it 'should request new translations when text_en has changed' do
        next_step = FactoryGirl.create(:next_step)
        next_step.text_en = 'hi'
        GengoCommunicator.any_instance.expects(:create_translation_jobs)
                         .with(next_step, 'text')
        next_step.save!
      end

      it 'wont request new translations when text_en has not changed' do
        next_step = FactoryGirl.create(:next_step)
        GengoCommunicator.any_instance.expects(:create_translation_jobs).never
        next_step.text_fr = 'salut'
        next_step.save!
      end
    end
  end

  describe 'methods' do
    describe '#date_of_oldest_missing_translation' do
      it 'should return the minimum created_at date within the existing data' do
        # create two categories without translations
        old = FactoryGirl.create(:next_step, created_at: Date.new(1970, 1, 1))
        FactoryGirl.create(:next_step, created_at: Date.new(1970, 1, 2))

        NextStep.date_of_oldest_missing_translation.must_equal old.created_at
      end
      it 'should ignore an older category if it has all translations' do
        old = FactoryGirl.create(:next_step, created_at: Date.new(1970, 1, 1))
        # set all translations (except for de and en)
        (I18n.available_locales - [:de, :en]).map do |locale|
          old.send("text_#{locale}=", 'Foobar')
        end
        old.save!
        newer = FactoryGirl.create(:next_step, created_at: Date.new(1970, 1, 2))
        NextStep.date_of_oldest_missing_translation.must_equal newer.created_at
      end
    end
  end
end
