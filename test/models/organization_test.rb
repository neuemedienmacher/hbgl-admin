# frozen_string_literal: true
require_relative '../test_helper'

describe Organization do
  subject { organization }

  describe 'partial_dup' do
    it 'should correctly duplicate an organization' do
      organization = FactoryGirl.create :organization, :approved
      duplicate = organization.partial_dup
      duplicate.name.must_equal nil
      duplicate.founded.must_equal nil
      duplicate.aasm_state.must_equal 'initialized'
    end
  end

  describe 'State Machine' do
    it 'should transition from approved to all_done and call mailings method' do
      organization = FactoryGirl.create :organization, aasm_state: 'approved'
      organization.expects(:apply_mailings_logic!).once
      organization.mark_as_done!
      organization.reload.must_be :all_done?
    end
  end

  describe '#apply_mailings_logic!' do
    it 'should call AsanaCommunicator for big_player-orga and dont change mailings' do
      organization = FactoryGirl.create :organization, :approved,
                                        mailings: 'disabled'
      # fake big organization (more than 9 locations)
      10.times do
        new_location = FactoryGirl.create :location
        organization.locations << new_location
      end
      organization.big_player?.must_equal true
      AsanaCommunicator.any_instance.expects(:create_big_orga_is_done_task)
                       .with(organization).once
      organization.send(:apply_mailings_logic!)
      organization.reload.mailings.must_equal 'big_player'
    end

    it 'wont create Asana Task but change mailings for small orga' do
      organization = FactoryGirl.create :organization, :approved,
                                        mailings: 'disabled'
      AsanaCommunicator.any_instance.expects(:create_big_orga_is_done_task).never
      organization.send(:apply_mailings_logic!)
      organization.reload.mailings.must_equal 'enabled'
    end

    it 'wont do anything for big_player organizations' do
      organization = FactoryGirl.create :organization, :approved,
                                        mailings: 'big_player'
      AsanaCommunicator.any_instance.expects(:create_big_orga_is_done_task).never
      organization.send(:apply_mailings_logic!)
      organization.reload.mailings.must_equal 'big_player'
    end

    it 'wont do anything for force_disabled organization' do
      organization = FactoryGirl.create :organization, :approved,
                                        mailings: 'force_disabled'
      AsanaCommunicator.any_instance.expects(:create_big_orga_is_done_task).never
      organization.send(:apply_mailings_logic!)
      organization.reload.mailings.must_equal 'force_disabled'
    end
  end

  describe '#big_player?' do
    it 'should be false for small organizations' do
      organization = FactoryGirl.create :organization, :approved
      organization.big_player?.must_equal false
    end

    it 'should be true for specific name and above location threshold' do
      organization = FactoryGirl.create :organization, :approved,
                                        name: 'AWO Nordrhein-Westfalen'
      # false, because location threshold is not reached with one location
      # organization.locations << (FactoryGirl.create :location)
      organization.big_player?.must_equal false
      # one more location => threshold reached
      organization.locations << (FactoryGirl.create :location)
      organization.big_player?.must_equal true
    end

    it 'should be true for big organizations' do
      organization = FactoryGirl.create :organization, :approved
      10.times do
        new_location = FactoryGirl.create :location
        organization.locations << new_location
      end
      organization.big_player?.must_equal true
    end
  end
end
