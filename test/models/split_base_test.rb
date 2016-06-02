# frozen_string_literal: true
require_relative '../test_helper'

describe SplitBase do
  describe 'methods' do
    describe '#display_name' do
      it 'should return correct name' do
        split_bases(:basic).display_name.must_equal(
          'foobar || basicSolutionCategoryName || '\
          'basicSplitBaseTitle || basicSplitBaseClaratAddition'
        )
      end
    end
  end
end
