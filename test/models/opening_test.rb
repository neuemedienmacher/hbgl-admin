# frozen_string_literal: true
require_relative '../test_helper'

describe Opening do
  let(:opening) do
    Opening.new(
      name: 'mon 00:00-01:00',
      day: 'mon',
      open: Time.zone.now,
      close: Time.zone.now + 1.hour
    )
  end

  subject { opening }

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :day }
      it { subject.must validate_presence_of :open }
      it { subject.must validate_uniqueness_of(:open).scoped_to([:day, :close]) }
      it { subject.must validate_presence_of :close }
      it { subject.must validate_uniqueness_of(:close).scoped_to([:day, :open]) }
    end
  end
end
