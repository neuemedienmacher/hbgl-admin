# frozen_string_literal: true
require_relative '../../test_helper'

class API::V1::FieldSet::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::FieldSet::Show }

  it 'should ignore the polymorphic association of assignments' do
    result = subject.new(Assignment).to_hash
    assert_nil result['associations'][:assignable]
  end

  it 'should correctly process the class_name' do
    result = subject.new(User).to_hash
    result['associations'][:created_assignments]['class-name'].must_equal 'assignments'
  end

  it 'should provide the correct associations for User class' do
    result = subject.new(User).to_hash
    result['associations'][:statistics]['key'].must_equal %w(trackable_id trackable_type)
    result['associations'][:authored_notes]['key'].must_equal ['user_id']
    result['associations'][:user_team_users]['key'].must_equal ['user_id']
    result['associations'][:user_teams]['key'].must_equal ['users.id']
    result['associations'][:led_teams]['key'].must_equal ['lead_id']
    result['associations'][:user_team_observing_users]['key'].must_equal ['user_id']
    result['associations'][:observed_user_teams]['key'].must_equal ['observing_users.id']
    result['associations'][:statistic_charts]['key'].must_equal ['user_id']
    result['associations'][:created_assignments]['key'].must_equal ['creator_id']
    result['associations'][:received_assignments]['key'].must_equal ['receiver_id']
    result['associations'][:versions]['key'].must_equal ['']
  end

  it 'should provide the correct associations for Organization class' do
    result = subject.new(Organization).to_hash
    result['associations'][:assignments]['key'].must_equal %w(assignable_id assignable_type)
    result['associations'][:translations]['key'].must_equal ['organization_id']
    result['associations'][:notes]['key'].must_equal %w(notable_id notable_type)
    result['associations'][:locations]['key'].must_equal ['organization_id']
    result['associations'][:divisions]['key'].must_equal ['organization_id']
    result['associations'][:website]['key'].must_equal [''] # ignores belongs_to to associations
    result['associations'][:contact_people]['key'].must_equal ['organization_id']
    result['associations'][:offers]['key'].must_equal ['organizations.id']
    result['associations'][:emails]['key'].must_equal ['organizations.id']
    result['associations'][:sections]['key'].must_equal ['organizations.id']
    result['associations'][:split_bases]['key'].must_equal ['organization_id']
    result['associations'][:cities]['key'].must_equal ['organizations.id']
    result['associations'][:definitions]['key'].must_equal ['organizations.id']
  end

  it 'should provide the correct associations for Division class' do
    result = subject.new(Division).to_hash
    result['associations'][:assignments]['key'].must_equal %w(assignable_id assignable_type)
    result['associations'][:organization]['key'].must_equal [''] # ignores belongs_to to associations
    result['associations'][:section]['key'].must_equal [''] # ignores belongs_to to associations
    result['associations'][:city]['key'].must_equal [''] # ignores belongs_to to associations
    result['associations'][:area]['key'].must_equal [''] # ignores belongs_to to associations
    result['associations'][:divisions_presumed_categories]['key'].must_equal ['division_id']
    result['associations'][:presumed_categories]['key'].must_equal ['presuming_divisions.id'] # TODO?!
    result['associations'][:divisions_presumed_solution_categories]['key'].must_equal ['division_id']
    result['associations'][:presumed_solution_categories]['key'].must_equal ['presuming_divisions.id']
    result['associations'][:websites]['key'].must_equal ['divisions.id']
  end

  it 'should provide the correct associations for City class' do
    result = subject.new(City).to_hash
    result['associations'][:locations]['key'].must_equal ['city_id']
    result['associations'][:divisions]['key'].must_equal ['city_id']
    result['associations'][:offers]['key'].must_equal ['location.city_id']
    result['associations'][:organizations]['key'].must_equal ['cities.id']
    result['associations'][:sections]['key'].must_equal ['cities.id']
  end
end
