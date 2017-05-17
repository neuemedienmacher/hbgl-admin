# frozen_string_literal: true
require_relative '../test_helper'

describe SolutionCategory do
  let(:category) { SolutionCategory.new }

  subject { category }

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :name }
    end
  end
end
