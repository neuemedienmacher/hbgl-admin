# frozen_string_literal: true

require_relative '../test_helper'

describe Category do
  let(:category) { Category.new }

  subject { category }

  describe 'callbacks' do
    describe 'after_save' do
      it 'should request new translations when saved for the first time' do
        category = FactoryGirl.build(:category)
        GengoCommunicator.any_instance.expects(:create_translation_jobs)
                         .with(category, 'name')
        category.save!
      end

      it 'should request new translations when name_en has changed' do
        category = FactoryGirl.create(:category)
        category.name_en = 'hi'
        GengoCommunicator.any_instance.expects(:create_translation_jobs)
                         .with(category, 'name')
        category.save!
      end

      it 'wont request new translations when name_en has not changed' do
        category = FactoryGirl.create(:category)
        GengoCommunicator.any_instance.expects(:create_translation_jobs).never
        category.name_fr = 'salut'
        category.save!
      end
    end
  end

  describe 'methods' do
    describe '#name_with_world_suffix_and_optional_asterisk' do
      it 'should return name with asterisk for a main category' do
        category.assign_attributes icon: 'x', name_de: 'a'
        category.sections = [sections(:family)]
        category.name_with_world_suffix_and_optional_asterisk.must_equal 'a(F)*'
      end
      it 'should return name without asterisk for a non-main category' do
        category.name_de = 'a'
        category.sections = [sections(:family)]
        category.name_with_world_suffix_and_optional_asterisk.must_equal 'a(F)'
      end
    end
  end
end
