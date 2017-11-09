# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
require_relative '../../support/utils/contract_test_utils'
# rubocop:disable ClassLength
class OfferContractTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils
  include ContractTestUtils
  let(:offer) { Offer::Contracts::Create.new(offers(:basic)) }

  subject { offer }

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :name }
      it { subject.must validate_presence_of :description }
      it { subject.must validate_presence_of :encounter }
      it { subject.must validate_presence_of :section }
      it { must_validate_length_of :code_word, maximum: 140 }

      it 'should fails if personal offer has no location' do
        subject.encounter = 'personal'
        subject.location = nil
        subject.wont_be :valid?
      end

      it 'should ensure a personal offer has a location' do
        subject = Offer::Contracts::Create.new(offers(:basic))
        subject.encounter = 'personal'
        subject.location = Location.new
        subject.must_be :valid?
      end

      it 'should fail if a remote offer has both location and an area' do
        subject.encounter = 'hotline'
        subject.location = Location.new
        subject.area = Area.new
        subject.wont_be :valid?
      end

      it 'should fail if a remote offer has location nut no area' do
        subject.encounter = 'hotline'
        subject.location = Location.new
        subject.area = nil
        subject.wont_be :valid?
      end

      it 'should fail if a remote offer has no location nor area' do
        subject.encounter = 'hotline'
        subject.location = nil
        subject.area = nil
        subject.wont_be :valid?
      end

      it 'should ensure a remote offer has no location but an area' do
        subject.encounter = 'hotline'
        subject.location = nil
        subject.area = Area.new
        subject.must_be :valid? # !
      end

      it 'should fail if locations and organizations do not match (personal)' do
        subject = Offer::Contracts::Update.new(offers(:basic))
        location = Location.new(organization: Organization.new)
        subject.location = location
        subject.wont_be :valid?
      end

      it 'should ensure locations and organizations match (personal)' do
        subject = Offer::Contracts::Update.new(offers(:basic))
        subject.location = Location.new(organization: organizations(:basic))
        subject.must_be :valid?
      end

      # it 'should ensure not all chosen organizations are expired' do
      #   subject.organizations.update_all aasm_state: 'expired'
      #   subject.wont_be :valid?
      # end
      #
      # it 'should ensure all chosen organizations are approved' do
      #   subject.organizations.update_all aasm_state: 'approved'
      #   subject.must_be :valid?
      # end

      it 'should fail when chosen contact people not SPoC nor belong to orga' do
        cp = FactoryGirl.create :contact_person, spoc: false,
                                                 organization_id:
                                                 organizations(:second).id
        subject.contact_people << cp
        subject.wont_be :valid?
      end

      it 'should ensure chosen contact people are SPoC' do
        cp = FactoryGirl.create :contact_person, spoc: true,
                                                 organization_id:
                                                 organizations(:second).id
        subject.contact_people << cp
        subject.must_be :valid?
      end

      it 'should ensure chosen contact people belong to orga' do
        cp = FactoryGirl.create :contact_person,
                                spoc: false, offers: [subject.model],
                                organization: organizations(:basic)
        subject.contact_people << cp
        subject.must_be :valid?
      end

      it 'should fail when more than 10 next steps are chosen' do
        10.times do |i| # basic offer has one next step
          subject.next_steps << NextStep.create(text_de: i, text_en: i)
        end
        subject.wont_be :valid?
      end

      it 'should succeed when no more than 10 next steps are chosen' do
        9.times do |i|
          subject.next_steps << NextStep.create(text_de: i, text_en: i)
        end
        subject.must_be :valid?
      end

      # it 'should validate presence of expiration date' do
      #   subject.expires_at = nil
      #   subject.valid?.must_equal false
      # end
      #
      # it 'should validate if expires_at is in future and starts_at not set' do
      #   subject.expires_at = Time.zone.now + 1.day
      #   subject.valid?.must_equal true
      # end
      #
      # it 'should fail if start_date > expires_at' do
      #   subject.expires_at = Time.zone.now + 1.day
      #   subject.starts_at = Time.zone.now + 2.days
      #   subject.valid?.must_equal false
      # end
      #
      # it 'should validate start date is before expires_at' do
      #   subject.expires_at = Time.zone.now + 1.day
      #   subject.starts_at = Time.zone.now
      #   subject.valid?.must_equal true
      # end

      it 'should fail when version < 7' do
        subject.logic_version = LogicVersion.create(name: 'chunky', version: 6)
        subject.divisions = []
        subject.valid?
        subject.errors.messages[:divisions].must_be :empty?
      end

      it 'should fail when divisions is nil with version >= 7' do
        subject.logic_version = LogicVersion.create(name: 'bacon', version: 7)
        subject.divisions = []
        subject.valid?
        subject.errors.messages[:divisions].wont_be :empty?
      end

      it 'should validate that division is assigned with version >= 7' do
        subject.logic_version = LogicVersion.create(name: 'bacon', version: 7)
        subject.divisions << divisions(:basic)
        subject.valid?
        subject.errors.messages[:divisions].must_be :empty?
      end

      it 'should validate that divisions have same section' do
        section = FactoryGirl.create(:section)
        division1 = FactoryGirl.create(:division, section: section)
        division2 = FactoryGirl.create(:division, section: section)
        subject.logic_version = LogicVersion.create(name: 'bacon', version: 7)
        subject.divisions = [division2, division1]
        subject.valid?
        subject.errors.messages[:divisions].must_be :empty?
      end

      it 'should fail if divisions have different section' do
        division1 = FactoryGirl.create(:division,
                                       section: FactoryGirl.create(:section))
        division2 = FactoryGirl.create(:division,
                                       section: FactoryGirl.create(:section))
        subject.logic_version = LogicVersion.create(name: 'bacon', version: 7)
        subject.divisions << [division2, division1]
        subject.valid?
        subject.errors.messages[:divisions].wont_be :empty?
      end

      # it 'should ensure chosen contact people belong to a chosen orga' do
      #   subject.reload.wont_be :valid?
      #   subject.reload.must_be :valid?
      # end
    end

    describe 'on update' do
      subject { offers(:basic) }
      it { subject.must validate_presence_of :target_audience_filters_offers }
    end
  end
end
# rubocop:enable ClassLength
