# frozen_string_literal: true

require_relative '../test_helper'

describe Filter do
  let(:filter) { Filter.new }

  subject { filter }

  describe 'validations' do
    describe 'TargetAudienceFilter' do
      it { TargetAudienceFilter.new.must belong_to :section }
    end
  end
end
