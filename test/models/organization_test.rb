# frozen_string_literal: true

require_relative '../test_helper'

describe Organization do
  let(:organization) do
    Organization.new(name: 'Testname',
                     description: 'Testbeschreibung',
                     legal_form: 'ev')
  end # Necessary to test uniqueness
  let(:orga) { organizations(:basic) }
  subject { organization }

  describe 'partial_dup' do
    it 'should correctly duplicate an organization' do
      organization = FactoryGirl.create :organization, :approved
      duplicate = organization.partial_dup
      assert_nil duplicate.name
      assert_nil duplicate.founded
      duplicate.aasm_state.must_equal 'initialized'
    end
  end

  describe 'State Machine' do
    describe 'initialized' do
      it 'should complete' do
        organization.complete
        organization.must_be :completed?
      end

      it 'wont approve' do
        assert_raises(AASM::InvalidTransition) { organization.approve }
        organization.must_be :initialized?
      end

      it 'wont deactivate_internal' do
        assert_raises(AASM::InvalidTransition) do
          organization.deactivate_internal
        end
        organization.must_be :initialized?
      end

      it 'wont deactivate_external' do
        assert_raises(AASM::InvalidTransition) do
          organization.deactivate_external
        end
        organization.must_be :initialized?
      end
    end

    describe 'completed' do
      before { organization.aasm_state = :completed }

      it 'should not enter approval_process when orga is not valid' do
        assert_raises(AASM::InvalidTransition) do
          organization.start_approval_process
        end
        organization.orga_valid?.must_equal false
      end

      it 'should enter approval_process when orga is valid' do
        organization.website = websites(:basic)
        organization.start_approval_process
        organization.orga_valid?.must_equal true
        organization.must_be :approval_process?
      end

      it 'should enter under_construction_pre' do
        organization.website_under_construction
        organization.must_be :under_construction_pre?
      end

      it 'wont complete' do
        assert_raises(AASM::InvalidTransition) { organization.complete }
        organization.must_be :completed?
      end

      it 'wont deactivate_internal' do
        assert_raises(AASM::InvalidTransition) do
          organization.deactivate_internal
        end
        organization.must_be :completed?
      end

      it 'wont deactivate_external' do
        assert_raises(AASM::InvalidTransition) do
          organization.deactivate_external
        end
        organization.must_be :completed?
      end
    end

    describe 'approval_process' do
      before { organization.aasm_state = :approval_process }

      it 'should approve with a different actor' do
        organization.stubs(:different_actor?).returns(true)
        organization.approve
        organization.must_be :approved?
      end

      it 'wont complete' do
        assert_raises(AASM::InvalidTransition) { organization.complete }
        organization.must_be :approval_process?
      end
    end

    describe 'approved' do
      before { organization.aasm_state = :approved }

      it 'wont complete' do
        assert_raises(AASM::InvalidTransition) { organization.complete }
        organization.must_be :approved?
      end

      it 'wont approve' do
        assert_raises(AASM::InvalidTransition) { organization.approve }
        organization.must_be :approved?
      end

      it 'must deactivate_internal' do
        organization.deactivate_internal
        organization.must_be :internal_feedback?
      end

      it 'must deactivate_external' do
        organization.deactivate_external
        organization.must_be :external_feedback?
      end
    end

    describe 'internal_feedback' do
      before { organization.aasm_state = :internal_feedback }

      it 'wont complete' do
        assert_raises(AASM::InvalidTransition) { organization.complete }
        organization.must_be :internal_feedback?
      end

      it 'must approve, even with same actor' do
        organization.stubs(:different_actor?).returns(false)
        organization.approve
        organization.must_be :approved?
      end

      it 'wont deactivate_internal' do
        assert_raises(AASM::InvalidTransition) do
          organization.deactivate_internal
        end
        organization.must_be :internal_feedback?
      end

      it 'must deactivate_external' do
        organization.deactivate_external
        organization.must_be :external_feedback?
      end
    end

    describe 'external_feedback' do
      before { organization.aasm_state = :external_feedback }

      it 'wont complete' do
        assert_raises(AASM::InvalidTransition) { organization.complete }
        organization.must_be :external_feedback?
      end

      it 'must approve, even with same actor' do
        organization.stubs(:different_actor?).returns(false)
        organization.approve
        organization.must_be :approved?
      end

      it 'must deactivate_internal' do
        organization.deactivate_internal
        organization.must_be :internal_feedback?
      end

      it 'wont deactivate_external' do
        assert_raises(AASM::InvalidTransition) do
          organization.deactivate_external
        end
        organization.must_be :external_feedback?
      end
    end

    describe 'all_done' do
      before { organization.aasm_state = :all_done }

      it 'must deactivate_internal' do
        organization.deactivate_internal
        organization.must_be :internal_feedback?
      end

      it 'must deactivate_external' do
        organization.deactivate_external
        organization.must_be :external_feedback?
      end

      it 'wont approve' do
        assert_raises(AASM::InvalidTransition) do
          organization.approve
        end
        organization.must_be :all_done?
      end

      it 'wont enter approval_process' do
        assert_raises(AASM::InvalidTransition) do
          organization.start_approval_process
        end
        organization.must_be :all_done?
      end
    end

    describe 'deactivate_offers!' do
      it 'should deactivate an approved offer belonging to this organization' do
        orga.offers.first.must_be :approved?
        orga.update_column :aasm_state, :internal_feedback
        orga.deactivate_offers!
        orga.offers.first.must_be :organization_deactivated?
      end

      it 'should raise an error when deactivation fails for an offer' do
        Offer.any_instance.expects(:deactivate_through_organization!)
             .returns(false)

        assert_raise(RuntimeError) { orga.deactivate_offers! }
      end
    end

    describe 'reactivate_offers!' do
      let(:offer) { offers(:basic) }

      it 'should reactivate an associated organization_deactivated offer' do
        # stub for translation-method stump to test functionality
        Organization.any_instance.stubs(:generate_translations!).returns true
        Offer.any_instance.stubs(:generate_translations!).returns true
        offer.update_column :aasm_state, :organization_deactivated
        orga.reactivate_offers!
        offer.reload.must_be :approved?
      end

      it 'should approve the orga and its offers when the event is used' do
        # stub for translation-method stump to test functionality
        Organization.any_instance.stubs(:generate_translations!).returns true
        Offer.any_instance.stubs(:generate_translations!).returns true
        orga.update_column :aasm_state, :internal_feedback
        offer.update_column :aasm_state, :organization_deactivated
        orga.approve_with_deactivated_offers!
        offer.reload.must_be :approved?
        orga.reload.must_be :approved?
      end

      it 'wont approve offers that have another deactivated orga' do
        offer.update_column :aasm_state, :organization_deactivated
        division = FactoryGirl.create(:division) # new division with orga
        offer.divisions << division
        division.organization.update_columns aasm_state: 'external_feedback'
        orga.reactivate_offers!
        offer.reload.must_be :organization_deactivated?
      end
    end

    describe 'deactivate_offers_to_under_construction!' do
      let(:offer) { offers(:basic) }
      it 'should deactivate an offer belonging to this organization and \
          re-activate it properly' do
        # stub for translation-method stump to test functionality
        Organization.any_instance.stubs(:generate_translations!).returns true
        Offer.any_instance.stubs(:generate_translations!).returns true
        orga.offers.first.must_be :approved?
        orga.website_under_construction!
        orga.offers.first.must_be :under_construction?
        orga.approve_with_deactivated_offers!
        orga.offers.first.reload.must_be :approved?
      end

      it 'should work from deactivated state but ignore offers' do
        orga.offers.first.must_be :approved?
        orga.deactivate_internal!
        orga.offers.first.must_be :organization_deactivated?
        orga.website_under_construction!
        orga.offers.first.must_be :organization_deactivated?
        orga.must_be :under_construction?
      end

      it 'should raise an error when deactivation fails for an offer' do
        Offer.any_instance.expects(:website_under_construction!)
             .returns(false)

        assert_raise(RuntimeError) do
          orga.deactivate_offers_to_under_construction!
        end
      end
    end

    describe '#different_actor?' do
      it 'should return true when created_by differs from current_actor' do
        orga.created_by = 99
        orga.send(:different_actor?).must_equal true
      end

      it 'should return falsy when created_by is nil' do
        orga.created_by = nil
        orga.send(:different_actor?).must_equal false
      end

      it 'should return false when current_actor is nil' do
        orga.created_by = 1
        Creator::Twin.any_instance.stubs(:current_actor).returns(nil)
        orga.send(:different_actor?).must_equal false
      end
    end

    it 'should transition from approved to all_done and call mailings method' do
      organization = FactoryGirl.create :organization, aasm_state: 'approved'
      organization.expects(:enable_mailings!).once
      organization.mark_as_done!
      organization.reload.must_be :all_done?
    end
  end

  describe '#enable_mailings!' do
    it 'will enable mailings for orga' do
      organization = FactoryGirl.create :organization, :approved,
                                        mailings: 'disabled'
      organization.send(:enable_mailings!)
      organization.reload.mailings.must_equal 'enabled'
    end

    it 'wont do anything for force_disabled organization' do
      organization = FactoryGirl.create :organization, :approved,
                                        mailings: 'force_disabled'
      organization.send(:enable_mailings!)
      organization.reload.mailings.must_equal 'force_disabled'
    end
  end
end
