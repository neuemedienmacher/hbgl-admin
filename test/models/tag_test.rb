# frozen_string_literal: true

require_relative '../test_helper'

describe Tag do
  let(:tag) { Tag.new }

  subject { tag }

  describe 'callbacks' do
    describe 'after_save' do
      it 'should request new translations when saved for the first time' do
        tag = FactoryBot.build(:tag)
        GengoCommunicator.any_instance.expects(:create_translation_jobs)
                         .with(tag, 'name')
        tag.save!
      end

      it 'should request new translations when name_en has changed' do
        tag = FactoryBot.create(:tag)
        tag.name_en = 'hi'
        GengoCommunicator.any_instance.expects(:create_translation_jobs)
                         .with(tag, 'name')
        tag.save!
      end

      it 'wont request new translations when name_en has not changed' do
        tag = FactoryBot.create(:tag)
        GengoCommunicator.any_instance.expects(:create_translation_jobs).never
        tag.name_fr = 'salut'
        tag.save!
      end
    end
  end
end
