# frozen_string_literal: true
require_relative '../test_helper'

describe NextStep do
  let(:next_step) { NextStep.new }
  subject { next_step }

  describe 'validations' do
    it { subject.must validate_presence_of :text_de }
    it { subject.must validate_presence_of :text_en }
    it { subject.must validate_length_of(:text_de).is_at_most 255 }
    it { subject.must validate_length_of(:text_en).is_at_most 255 }
    it { subject.must validate_length_of(:text_ar).is_at_most 255 }
    it { subject.must validate_length_of(:text_fr).is_at_most 255 }
    it { subject.must validate_length_of(:text_tr).is_at_most 255 }
    it { subject.must validate_length_of(:text_pl).is_at_most 255 }
    it { subject.must validate_length_of(:text_ru).is_at_most 255 }
    it { subject.must validate_length_of(:text_fa).is_at_most 255 }
  end

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
end
