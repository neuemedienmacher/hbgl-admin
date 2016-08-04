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
      organization = FactoryGirl.create :organization, :approved
      organization.expects(:apply_mailings_logic!).once
      organization.mark_as_done!
      organization.reload.must_be :all_done?
    end
  end

  describe '#apply_mailings_logic!' do
    it 'should call AsanaCommunicator for big_player-orga and dont change mailings' do
      organization = FactoryGirl.create :organization, :approved,
                                        mailings: 'big_player'
      AsanaCommunicator.any_instance.expects(:create_big_orga_is_done_task).once
      organization.send(:apply_mailings_logic!)
      organization.reload.mailings.must_equal 'big_player'
    end

    it 'wont create Asana Task and change mailings for small orga' do
      organization = FactoryGirl.create :organization, :approved
      AsanaCommunicator.any_instance.expects(:create_big_orga_is_done_task).never
      organization.send(:apply_mailings_logic!)
      organization.reload.mailings.must_equal 'enabled'
    end
  end

  describe '#big_orga_or_big_player?' do
    it 'should be true for big_player' do
      organization = FactoryGirl.create :organization, :approved,
                                        mailings: 'big_player'
      organization.big_orga_or_big_player?.must_equal true
    end

    # TODO: big orga
  end
end
