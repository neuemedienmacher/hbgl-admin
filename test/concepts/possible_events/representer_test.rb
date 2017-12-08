# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::PossibleEvents::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::PossibleEvents::Show }

  it 'should return possible events for an initialized organization' do
    organization = organizations(:basic)
    organization.aasm_state = 'initialized'
    result = subject.new(organization).to_hash
    result['data'].map { |k| k[:name] if k[:possible] }.compact
                  .must_equal %i[complete website_under_construction]
  end

  it 'should return possible events for an approved offer' do
    result = subject.new(offers(:basic)).to_hash
    result['data'].map { |k| k[:name] if k[:possible] }.compact
                  .must_equal %i[expire deactivate_internal deactivate_external
                                 website_under_construction
                                 start_checkup_process]
  end

  it 'should return failing guards for an invalid orga' do
    organization = organizations(:basic)
    organization.update_columns(aasm_state: 'completed', website_id: nil)
    result = subject.new(organization).to_hash
    result['data'].map { |k| k[:failing_guards] }.flatten
                  .compact.must_equal %i[orga_valid?]
  end

  it 'should return possible events for a Division' do
    division = FactoryBot.create :division
    # division with not-approved orga return an empty array
    division.organization.update_columns aasm_state: 'initialized'
    result = subject.new(division).to_hash
    result['data'].must_equal [
      { name: :mark_as_done, possible: false, failing_guards: [] },
      { name: :mark_as_not_done, possible: false, failing_guards: [] }
    ]
    # not-done-division with approved orga returns mark_as_done
    division.organization.update_columns aasm_state: 'approved'
    result = subject.new(division).to_hash
    result['data'].must_equal [
      { name: :mark_as_done, possible: true, failing_guards: [] },
      { name: :mark_as_not_done, possible: false, failing_guards: [] }
    ]
    # done-division with all_done orga returns mark_as_not_done
    division.done = true
    division.organization.update_columns aasm_state: 'all_done'
    result = subject.new(division).to_hash
    result['data'].must_equal [
      { name: :mark_as_done, possible: false, failing_guards: [] },
      { name: :mark_as_not_done, possible: true, failing_guards: [] }
    ]
  end

  it 'should return an empty array for any other model' do
    result = subject.new(locations(:basic)).to_hash
    result['data'].must_equal []
  end
end
