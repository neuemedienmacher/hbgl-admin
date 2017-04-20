# frozen_string_literal: true
require_relative '../test_helper'

describe Filter do
  let(:filter) { Filter.new }

  subject { filter }

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :name }
      it { subject.must validate_uniqueness_of :name }
      it { subject.must validate_presence_of :identifier }
      it { subject.must validate_uniqueness_of :identifier }
    end

    describe 'LanguageFilter' do
      it { LanguageFilter.new.must validate_length_of :identifier }
    end

    describe 'TargetAudienceFilter' do
      it { TargetAudienceFilter.new.must belong_to :section_filter }
    end

    describe 'SectionFilter' do
      it { SectionFilter.new.must have_many :target_audience_filters }
    end
  end
end
