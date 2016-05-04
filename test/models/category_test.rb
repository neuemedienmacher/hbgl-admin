# frozen_string_literal: true
require_relative '../test_helper'

describe Category do
  let(:category) { Category.new }

  subject { category }

  describe 'methods' do
    describe '#name_with_world_suffix_and_optional_asterisk' do
      it 'should return name with asterisk for a main category' do
        category.assign_attributes icon: 'x', name_de: 'a'
        category.section_filters = [filters(:family)]
        category.name_with_world_suffix_and_optional_asterisk.must_equal 'a(F)*'
      end
      it 'should return name without asterisk for a non-main category' do
        category.name_de = 'a'
        category.section_filters = [filters(:family)]
        category.name_with_world_suffix_and_optional_asterisk.must_equal 'a(F)'
      end
    end
  end
end
