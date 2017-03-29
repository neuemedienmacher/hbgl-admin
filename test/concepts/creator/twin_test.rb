# frozen_string_literal: true
require_relative '../../test_helper'

class Creator::TwinTest < ActiveSupport::TestCase
  let(:subject) { offers(:basic) }

  describe '#creator' do
    it 'should return anonymous by default' do
      subject.update_columns created_by: nil
      twin = Creator::Twin.new(subject)
      twin.creator.must_equal 'anonymous'
    end

    it 'should return users name if there is a version' do
      twin = Creator::Twin.new(subject)
      twin.creator.must_equal User.find(subject.created_by).name
    end
  end

  describe '#different_actor?' do
    it 'should return true when created_by differs from current_actor' do
      subject.update_columns created_by: 99
      Creator::Twin.any_instance.stubs(:current_actor).returns(42)
      twin = Creator::Twin.new(subject)
      twin.send(:different_actor?).must_equal true
    end

    it 'should return false when created_by is the same as current_actor' do
      twin = Creator::Twin.new(subject)
      Creator::Twin.any_instance.stubs(:current_actor).returns(subject.created_by)
      twin.send(:different_actor?).must_equal false
    end

    it 'should return false when created_by is nil' do
      subject.update_columns created_by: nil
      twin = Creator::Twin.new(subject)
      twin.send(:different_actor?).must_equal false
    end

    it 'should return false when current_actor is nil' do
      Creator::Twin.any_instance.stubs(:current_actor).returns(nil)
      twin = Creator::Twin.new(subject)
      twin.send(:different_actor?).must_equal false
    end
  end
end
