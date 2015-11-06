require_relative '../test_helper'

describe Offer do
  let(:offer) { Offer.new }

  subject { offer }

  describe '::Base' do
    describe 'associations' do
      it { subject.must have_many :offer_mailings }
      it { subject.must have_many(:informed_emails).through :offer_mailings }
    end
  end
end
