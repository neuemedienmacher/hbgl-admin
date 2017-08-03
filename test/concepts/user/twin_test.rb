# frozen_string_literal: true
require_relative '../../test_helper'

class User::TwinTest < ActiveSupport::TestCase
  describe '#presumed_section' do
    it 'should return family for a singular team classification' do
      user = users(:researcher)
      user.user_teams << user_teams(:basic)
      User::Twin.new(user).presumed_section.must_equal 'family'
    end

    it 'should return first classification for multiple teams' do
      user = users(:researcher)
      user.user_teams << user_teams(:basic)
      user.user_teams << user_teams(:super)
      User::Twin.new(user).presumed_section.must_equal 'family'
      # remove family team => refugees is found
      user.user_teams.delete(user_teams(:basic))
      User::Twin.new(user).presumed_section.must_equal 'refugees'
    end
  end
end
