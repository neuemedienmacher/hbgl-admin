# frozen_string_literal: true

require_relative '../test_helper'

describe NextStep do
  let(:next_step) { NextStep.new }
  subject { next_step }

  describe 'callbacks' do
    describe 'after_save' do
      it 'should request new translations when saved for the first time' do
        next_step = FactoryBot.build(:next_step)
        GengoCommunicator.any_instance.expects(:create_translation_jobs)
                         .with(next_step, 'text')
        next_step.save!
      end

      it 'should request new translations when text_en has changed' do
        next_step = FactoryBot.create(:next_step)
        next_step.text_en = 'hi'
        GengoCommunicator.any_instance.expects(:create_translation_jobs)
                         .with(next_step, 'text')
        next_step.save!
      end

      it 'wont request new translations when text_en has not changed' do
        next_step = FactoryBot.create(:next_step)
        GengoCommunicator.any_instance.expects(:create_translation_jobs).never
        next_step.text_fr = 'salut'
        next_step.save!
      end
    end
  end
end
