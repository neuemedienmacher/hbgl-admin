require_relative '../test_helper'

describe BaseOffer do
  describe 'methods' do
    describe '#display_name' do
      it 'should return correct name' do
        base_offers(:basic).display_name.must_equal 'basicBaseOfferName (1)'
      end
    end
  end
end
