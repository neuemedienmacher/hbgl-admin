# frozen_string_literal: true

require_relative '../test_helper'

describe Ability do
  describe 'User' do
    describe 'abilities' do
      it 'should be able to access everything as researcher' do
        user = FactoryGirl.create :researcher
        ability = Ability.new(user)

        assert ability.can?(:access, :rails_admin)

        assert ability.can?(:index, :all)
        assert ability.can?(:new, :all)
        assert ability.can?(:export, :all)
        assert ability.can?(:history, :all)
        assert ability.can?(:destroy, :all)

        assert ability.can?(:show, :all)
        assert ability.can?(:edit, :all)
        assert ability.can?(:show_in_app, :all)
        assert ability.can?(:history, :all)
        assert ability.can?(:clone, :all)
        assert ability.can?(:nestable, :all)
        assert ability.can?(:change_state, :all)
      end
    end
  end
end
