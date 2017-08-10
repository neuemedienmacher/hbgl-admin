# frozen_string_literal: true
require_relative '../test_helper'

describe City do
  let(:city) { City.new }

  subject { city }

  describe '::Base' do
    describe 'associations' do
      it { subject.must have_many :locations }
      it { subject.must have_many(:offers).through :locations }
      it { subject.must have_many(:organizations).through :locations }
    end
  end
end
