# frozen_string_literal: true
require_relative '../test_helper'

describe FederalState do
  let(:federal_state) { FederalState.new }

  subject { federal_state }

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :name }
      it { subject.must validate_uniqueness_of :name }
    end
  end
end
